//
//  PostBlock.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/14/24.
//

import SwiftUI
import FaviconFinder

struct PostBlock: View {
    let post: Post
    
    @State var favicon: UIImage?
    
    var body: some View {
        HStack {
            VStack(spacing: 5) {
                HStack {
                    Text(post.title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                if let url = post.url, let host = url.host {
                    HStack {
                        Image(systemName: "link")
                        Text(host).font(.subheadline)
                        Spacer()
                    }
                    .task {
                        do {
                            favicon = try await FaviconFinder(url: url)
                                .fetchFaviconURLs()
                                .largest()
                                .download()
                                .image?
                                .image
                        } catch {
                            print(error)
                        }
                    }
                }
                HStack {
                    Text("Posted \(post.createdAt.timeAgoDisplay())")
                    if let updatedAt = post.updatedAt {
                        Text("•")
                        Text("Updated \(updatedAt.timeAgoDisplay())")
                    }
                    Spacer()
                }
                .font(.footnote)
                .foregroundStyle(.foreground.opacity(0.6))
                HStack {
                    Chip(icon: "arrow.up", text: post.score.description)
                    Chip(icon: "bubble", text: post.numComments.description)
                    Chip(icon: "person", text: post.author)
                    Spacer()
                    
                }
            }
            if let favicon = favicon {
                VStack {
                    Image(uiImage: favicon)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    PostBlock(post: Post(id: 41538471, title: "Why use metaphors in conflicts? Because understanding is remembering in disguise (2009)", author: "yamrzou", url: URL(string: "https://google.com"), storyText: nil, type: PostType.story, score: 67, createdAt: Date(timeIntervalSince1970: 1727234567), updatedAt: Date() - 1000, numComments: 6))
        .padding()
}
