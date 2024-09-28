//
//  SourceInterface.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/24/24.
//

import Foundation

protocol Source {
    func getHomepage(tag: HomepageViews) async throws -> [Post]
    func getComments(id: Int) async throws -> [Comment]
}

struct Post: Identifiable {
    let id: Int
    let title: String
    let author: String
    let url: URL?
    let storyText: String?
    let type: PostType
    let score: Int
    let createdAt: Date
    let updatedAt: Date?
    let numComments: Int
}

struct Comment: Identifiable {
    let id: Int
    let author: String
//    let createdAt: Date
//    let updatedAt: Date?
    let text: String
    let children: [Comment]
}

enum HomepageViews {
    case top
    case new
    case best
    case ask
    case show
    case job
}

enum PostType: String, Codable {
    case story
    case job
}
