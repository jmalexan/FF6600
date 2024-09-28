//
//  PostComments.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/14/24.
//

import SwiftUI

struct PostComments: View {
    let post: Post
    @State var comments: [Comment]?
    
    let client = HNClient()
    
    var body: some View {
        ScrollView {
            VStack {
                PostBlock(post: post)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                Divider()
                if let comments = comments {
                    LazyVStack(spacing: 20) {
                        ForEach(Array(comments.enumerated()), id: \.offset) { (index, comment) in
                            CommentView(comment: comment)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                } else {
                    ProgressView()
                        .padding(.top, 50)
                }
                Spacer()
            }
            .task(id: post.id) {
                comments = nil
                do {
                    comments = try await client.getComments(id: post.id)
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    PostComments(post: Post(id: 41538471, title: "Why use metaphors in conflicts? Because understanding is remembering in disguise (2009)", author: "yamrzou", url: URL(string: "https://westallen.typepad.com/brains_on_purpose/2009/06/why-use-metaphors-because-understanding-is-remembering-in-disguise.html"), storyText: nil, type: PostType.story, score: 67, createdAt: Date(), updatedAt: nil, numComments: 6))
}
