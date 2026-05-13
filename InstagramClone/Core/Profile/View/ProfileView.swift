//
//  ProfileView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    @StateObject private var gridViewModel: PostGridViewModel

    init(user: User) {
        self.user = user
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
            ProfileHeaderView(user: user)
            // posts

            PostGridView(viewModel: gridViewModel, configuration: .profile)

        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(user: MockData.users[1])
}
