//
//  ProfileView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var userManager: UserManager
    
    @State private var isSettingsPresented = false
    @StateObject private var gridViewModel = PostGridViewModel(
        service: ProfilePostGridService(),
        likePostService: LikePostService(),
        savePostService: SavePostService(),
        userService: UserService()
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                if let currentUser = userManager.currentUser {
                    // header
                    ProfileHeaderView(user: currentUser)
                    // posts
                    PostGridView(viewModel: gridViewModel, configuration: .profile)

                }
            }
            .sheet(isPresented: $isSettingsPresented, content: {
                SettingsView()
            })
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSettingsPresented.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.black)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
}

#Preview {
    CurrentUserProfileView()
}
