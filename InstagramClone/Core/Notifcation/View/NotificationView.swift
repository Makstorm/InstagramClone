//
//  NotificationView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject private var userManager: UserManager
    @StateObject private var viewModel: NotificationsViewModel
    @StateObject private var followRequestsViewModel: FollowRequestsViewModel
    
    init() {
        let userService = UserService()
        
        self._viewModel = StateObject(
            wrappedValue: NotificationsViewModel(
                service: NotificationService(),
                userService: userService
            )
        )
        
        self._followRequestsViewModel = StateObject(
            wrappedValue: FollowRequestsViewModel(
                followRequestService: FollowRequestService(),
                userService: userService
            )
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if isPrivateProfile {
                    FollowRequestsNotificationCell()
                        .environmentObject(followRequestsViewModel)
                        .padding(.top)
                }
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.notifications) { notification in
                        NotificationCell(notification: notification)
                            .padding(.top)
                    }
                }
            }
            .task { await fetchFollowRequests() }
            .task { await viewModel.fetchNotifications() }
            .refreshable { await viewModel.fetchNotifications() }
//            .navigationDestination(for: Post.self, destination: { post in
//                FeedCell(post: post)
//            })
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user)
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension NotificationView {
    var isPrivateProfile: Bool {
        return userManager.currentUser?.isPrivate ?? false
    }

    func fetchFollowRequests() async {
        guard let currentUser = userManager.currentUser, currentUser.isPrivate else { return }
        await followRequestsViewModel.fetchRequests()
    }
}

#Preview {
    NotificationView()
}
