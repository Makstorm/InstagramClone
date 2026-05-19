//
//  SavedPostsView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 10.05.2026.
//

import SwiftUI

struct SavedPostsView: View {
    @StateObject private var gridViewModel = PostGridViewModel(
        service: SavedPostGridService(),
        likePostService: LikePostService(),
        savePostService: SavePostService(),
        userService: UserService(),
        notificationManager: NotificationManager(service: NotificationManagerService())
    )
    
    var body: some View {
        ScrollView {
            PostGridView(viewModel: gridViewModel, configuration: .savedPosts)
        }
        .refreshable { await gridViewModel.refreshPosts() }
        .navigationTitle("Saved Posts")
    }
}

#Preview {
    SavedPostsView()
}
