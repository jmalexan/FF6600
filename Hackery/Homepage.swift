//
//  Homepage.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/14/24.
//

import SwiftUI

struct Homepage: View {
    @State var posts: [Post]?;
    
    var client = HNClient()
    
    var body: some View {
        NavigationSplitView {
            VStack {
                if let posts {
                    ScrollView {
                        ForEach(Array(posts.enumerated()), id: \.offset) { i, post in
                            if i != 0 {
                                Divider()
                            }
                            NavigationLink {
                                PostComments(post: post)
                            } label: {
                                PostBlock(post: post)
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                } else {
                    ProgressView()
                }
            }.task {
                do {
                    posts = try await client.getHomepage(tag: HomepageViews.top)
                } catch {
                    print(error)
                }
            }
            .navigationTitle("Homepage")
            .refreshable {
                do {
                    self.posts = try await client.getHomepage(tag: HomepageViews.top)
                } catch {
                    print(error)
                }
            }
            .navigationSplitViewColumnWidth(ideal: 400)
        } detail: {
            
        }
    }
}

#Preview {
    Homepage()
}
