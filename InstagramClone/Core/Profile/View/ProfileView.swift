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
                user: user
            )
        )
        self._gridViewModel = StateObject(
            wrappedValue: PostGridViewModel(
                service: ProfilePostGridService(user: user),
                likePostService: LikePostService(),
                savePostService: SavePostService(),
                userService: UserService()
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
        .task { await profileViewModel.checkIfUserIsFollowed() }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ProfileView {
    func handleFollowTapped() {
        guard let isFollowed = profileViewModel.user.isFollowed else { return }
        if isFollowed {
            profileViewModel.unfollow()
        } else {
            profileViewModel.follow()
        }
    }
}

#Preview {
    ProfileView(user: MockData.users[1])
}
