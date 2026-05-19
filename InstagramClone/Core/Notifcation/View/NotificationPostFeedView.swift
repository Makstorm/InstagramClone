//
//  NotificationPostFeedView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 19.05.2026.
//

import SwiftUI

struct NotificationPostFeedView: View {
    @StateObject private var feedViewModel = NotificationPostFeedViewModel()
    
    private let post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        ScrollView{
            ForEach(feedViewModel.posts) {post in
                FeedCell(post: post, viewModel: feedViewModel)
            }
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
        .task { await configureFeedViewModel(with: post) }
    }
}

private extension NotificationPostFeedView {
    func configureFeedViewModel(with post: Post) async {
        feedViewModel.posts = [post]
        await feedViewModel.configurePostUserData()
    }
}

#Preview {
    NotificationPostFeedView(post: MockData.posts[0])
}
