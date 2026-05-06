//
//  NotificationView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var viewModel = NotificationsViewModel(
        service: NotificationService(),
        userService: UserService()
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.notifications) { notification in
                        NotificationCell(notification: notification)
                            .padding(.top)
                    }
                }
            }
            .refreshable { Task { await viewModel.fetchNotifications() }
            }
            .navigationDestination(for: Post.self, destination: { post in
                ScrollView {
                    VStack {
                        FeedCell(post: post)
                    }
                }
            })
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user)
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NotificationView()
}
