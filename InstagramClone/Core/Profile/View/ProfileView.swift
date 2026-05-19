//
//  ProfileView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var gridViewModel: PostGridViewModel
    @StateObject private var profileViewModel: ProfileViewModel
    
    init(user: User) {
        self._profileViewModel = StateObject(
            wrappedValue: ProfileViewModel(
                user: user,
                followService: FollowService(),
                notificationManager: NotificationManager(service: NotificationManagerService())
            )
        )
        self._gridViewModel = StateObject(
            wrappedValue: PostGridViewModel(
                service: ProfilePostGridService(user: user),
                likePostService: LikePostService(),
                savePostService: SavePostService(),
                userService: UserService(),
                notificationManager: NotificationManager(service: NotificationManagerService())
            )
        )
    }

    var body: some View {
        ScrollView {
            // header
            ProfileHeaderView(user: profileViewModel.user, actionHandler: handleFollowTapped)
            // posts

            if profileViewModel.user.isPrivate {
                IGContentUnavailableView(
                    "This account is private.",
                    systemImage: "lock.circle",
                    description: "Request to follow this account to see their content."
                )
                .frame(height: 400)
            } else {
                PostGridView(viewModel: gridViewModel, configuration: .profile)
            }

        }
        .task { await profileViewModel.fetchUserStats() }
        .task { await profileViewModel.fetchUserRelationState() }
        .refreshable { await refresh() }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ProfileView {
    func handleFollowTapped() {
        switch profileViewModel.user.userRelationState {
        case .notFollowed:
            if profileViewModel.user.isPrivate {
                profileViewModel.sendFollowRequest()
            } else {
                profileViewModel.follow()
            }
        case .followed: profileViewModel.unfollow()
        case .requestedToFollow: profileViewModel.removeFollowRequest()
        case .blocked: print("DEBUG: Unblock user..")
        default: break
        }
    }
    
    func refresh() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await profileViewModel.fetchUserStats() }
            group.addTask { await profileViewModel.fetchUserRelationState() }
            group.addTask { await gridViewModel.refreshPosts() }
        }
    }
}

#Preview {
    ProfileView(user: MockData.users[1])
}
