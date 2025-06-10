//
//  HNClient.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/24/24.
//

import Foundation
import SwiftSoup

struct HNClient: Source {
    func getHomepage(tag: HomepageViews) async throws -> [Post] {
        guard let storiesUrl = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json") else {
            throw HNError.invalidUrl
        }
                                    
        let (HNResp, _) = try await URLSession.shared.data(from: storiesUrl)
                
        let decoder = JSONDecoder()
        let postIds = try decoder.decode(HNHomepage.self, from: HNResp)
        
        let pages = stride(from: 0, to: postIds.count, by: 50).map {
            Array(postIds[$0..<($0 + 50)])
        }
                
        let algoliaResps = try await withThrowingTaskGroup(of: Data.self, returning: [Data].self) { taskGroup in
            for page in pages {
                guard let algoliaUrl = URL(string: "http://hn.algolia.com/api/v1/search?tags=(story,job),(\(page.map({"story_\($0)"}).joined(separator: ",")))") else {
                    throw HNError.invalidUrl
                }
             
                taskGroup.addTask {
                    let (algoliaResp, _) = try await URLSession.shared.data(from: algoliaUrl)
                    return algoliaResp
                }
            }
            
            return try await taskGroup.reduce(into: [Data]()) { partialResult, resp in
                partialResult.append(resp)
            }
        }
        
        var algoliaPosts: [AlgoliaSearch.AlgoliaHit] = []
        
        for resp in algoliaResps {
            decoder.dateDecodingStrategy = .iso8601
            let algoliaPage = try decoder.decode(AlgoliaSearch.self, from: resp)
            algoliaPosts.append(contentsOf: algoliaPage.hits)
        }
        
        var postMap: [Int: AlgoliaSearch.AlgoliaHit] = [:]
        
        for hit in algoliaPosts {
            postMap[hit.storyID] = hit
        }
                
        var homepagePosts: [Post] = []
        
        for postId in postIds {
            if let hit = postMap[postId] {
                homepagePosts.append(Post(from: hit))
            }
        }
                        
        return homepagePosts
    }
    
    func getComments(id: Int) async throws -> [Comment] {
        guard let algoliaUrl = URL(string: "http://hn.algolia.com/api/v1/items/\(id)") else {
            throw HNError.invalidUrl
        }
        
        let (algoliaResp, _) = try await URLSession.shared.data(from: algoliaUrl)
                
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let items = try decoder.decode(AlgoliaItems.self, from: algoliaResp)
        
        guard let hnUrl = URL(string: "https://news.ycombinator.com/item?id=\(id)") else {
            throw HNError.invalidUrl
        }
        
        let (hnResp, _) = try await URLSession.shared.data(from: hnUrl)
        
        let htmlText = String(decoding: hnResp, as: Unicode.UTF8.self)
        let doc = try SwiftSoup.parse(htmlText)
        let comments = try doc.select(".comtr")
        let idOrder = comments.map { Int($0.id()) }.compactMap(\.self)

        return items.getComments(commentOrder: idOrder)
    }
}

enum HNError: Error {
    case invalidUrl
}

typealias HNHomepage = [Int]

struct AlgoliaSearch: Decodable {
    struct AlgoliaHit: Decodable {
        let author: String
        let createdAt: Date
        let numComments: Int
        let objectID: String
        let points: Int
        let storyID: Int
        let storyText: String?
        let title: String
        let updatedAt: Date
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case author, createdAt = "created_at", numComments = "num_comments", objectID, points, storyID = "story_id", storyText = "story_text", title, updatedAt = "updated_at", url
        }
    }
    let hits: [AlgoliaHit]
}

extension Post {
    init(from: AlgoliaSearch.AlgoliaHit) {
        id = from.storyID
        title = from.title
        author = from.author
        url = if let url = from.url {
            URL(string: url)
        } else {
            nil
        }
        storyText = from.storyText
        type = PostType.story
        score = from.points
        createdAt = from.createdAt
        updatedAt = from.updatedAt
        numComments = from.numComments
    }
}

struct AlgoliaItems: Decodable {
    struct AlgoliaComment: Identifiable, Decodable {
        let id: Int
//        let createdAt: Date
        let author: String
        let text: String
        let children: [AlgoliaComment]
    }
    let children: [AlgoliaComment]
    
    func getComments(commentOrder: [Int]? = nil) -> [Comment] {
        let unsortedComments = children.map {
            Comment(from: $0)
        }
        if let commentOrder {
            return unsortedComments.filter { commentOrder.contains($0.id) }.sorted {
                commentOrder.firstIndex(of: $0.id) ?? 0 < commentOrder.firstIndex(of: $1.id) ?? 0
            }
        } else {
            return unsortedComments
        }
    }
}

extension Comment {
    init(from: AlgoliaItems.AlgoliaComment, commentOrder: [Int]? = nil) {
        id = from.id
        author = from.author
        text = from.text
//        createdAt = from.createdAt
        var children: [Comment] = []
        for child in from.children {
            children.append(Comment(from: child))
        }
        if let commentOrder {
            children = children.filter { commentOrder.contains($0.id) }.sorted {
                commentOrder.firstIndex(of: $0.id) ?? 0 < commentOrder.firstIndex(of: $1.id) ?? 0
            }
        }
        self.children = children
    }
}
