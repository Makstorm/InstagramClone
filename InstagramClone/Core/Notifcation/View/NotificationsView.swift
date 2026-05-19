//
//  NotificationView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject private var userManager: UserManager
    
    @State private var activeScrollId: String?
    @State private var paginating = false
    
    @StateObject private var viewModel: NotificationsViewModel
    @StateObject private var followRequestsViewModel: FollowRequestsViewModel
    
    init() {
        let userService = UserService()
        let notificationManager = NotificationManager(service: NotificationManagerService())
        
        self._viewModel = StateObject(
            wrappedValue: NotificationsViewModel(
                service: NotificationFetchingService(),
                userService: userService,
                followService: FollowService(),
                notificationManager: notificationManager
            )
        )
        
        self._followRequestsViewModel = StateObject(
            wrappedValue: FollowRequestsViewModel(
                followRequestService: FollowRequestService(),
                userService: userService,
                notificationManager: notificationManager
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
                
                switch viewModel.loadingState {
                case .empty:
                    IGContentUnavailableView(
                        "Nothing to see here.",
                        systemImage: "bell.circle",
                        description: "Notifications will appear here when users interact with you."
                    )
                    .frame(height: 400)
                case .error:
                    Text("An error occured...")
                case .loading:
                    ProgressView()
                case .complete:
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.notifications) { notification in
                            NotificationCell(notification: notification)
                                .id(notification.id)
                                .environmentObject(viewModel)
                        }
                        
                        if paginating {
                            ProgressView()
                        }
                    }
                    .scrollTargetLayout()
                }
            }
            .scrollPosition(id: $activeScrollId, anchor: .bottom)
            .onChange(of: activeScrollId) { oldValue, newValue in
                loadMoreNotificationsIfNecessary(newValue)
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable { await viewModel.refreshNotifications() }
            .navigationDestination(for: Post.self, destination: { post in
                NotificationPostFeedView(post: post)
            })
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user)
            }
        }
        .task { await fetchFollowRequests() }
        .task { await viewModel.fetchNotifications() }
    }
}

private extension NotificationsView {
    var isPrivateProfile: Bool {
        return userManager.currentUser?.isPrivate ?? false
    }

    func fetchFollowRequests() async {
        guard let currentUser = userManager.currentUser, currentUser.isPrivate else { return }
        await followRequestsViewModel.fetchRequests()
    }
    
    func loadMoreNotificationsIfNecessary(_ activeScrollId: String?) {
        guard activeScrollId == viewModel.notifications.last?.id else { return }
        
        Task {
            paginating = true
            await viewModel.loadMoreNotifications()
            paginating = false
        }
    }
}

#Preview {
    NotificationsView()
}
