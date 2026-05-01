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

    var body: some View {
        NavigationStack {
            ScrollView {
                if let currentUser = userManager.currentUser {
                    // header
                    ProfileHeaderView(user: currentUser)
                    // posts
                    PostGridView(user: currentUser)

                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        authManager.signOut()
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
