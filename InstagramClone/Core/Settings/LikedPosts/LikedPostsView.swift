//
//  LikedPostsView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 10.05.2026.
//

import SwiftUI

struct LikedPostsView: View {
    @StateObject private var gridViewModel = PostGridViewModel(
        service: LikedPostGridService(),
        likePostService: LikePostService(),
        savePostService: SavePostService(),
        userService: UserService(),
        notificationManager: NotificationManager(service: NotificationManagerService())
    )

    var body: some View {
        ScrollView {
            PostGridView(viewModel: gridViewModel, configuration: .likedPosts)
        }
        .navigationTitle("Liked Posts")
    }
}

#Preview {
    LikedPostsView()
}
