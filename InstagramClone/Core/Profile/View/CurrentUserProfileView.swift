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
    
    @State private var sheetConfig: SheetConfiguration?
    
    @StateObject private var gridViewModel = PostGridViewModel(
        service: ProfilePostGridService(),
        likePostService: LikePostService(),
        savePostService: SavePostService(),
        userService: UserService(),
        notificationManager: NotificationManager(service: NotificationManagerService())
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                if let currentUser = userManager.currentUser {
                    // header
                    ProfileHeaderView(user: currentUser) { sheetConfig = .editProfile }
                    // posts
                    PostGridView(viewModel: gridViewModel, configuration: .profile)

                }
            }
            .refreshable { await refresh() }
            .task { await userManager.fetchUserStats() }
            .fullScreenCover(item: $sheetConfig) { config in
                switch config {
                case .settings:
                    SettingsView()
                case .editProfile:
                    if let user = userManager.currentUser {
                        EditProfileView(user: user)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { sheetConfig = .settings } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.black)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
}

private extension CurrentUserProfileView {
    enum SheetConfiguration: Int, Identifiable {
        case settings
        case editProfile
        
        var id: Int { return self.rawValue }
    }
    
    func refresh() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await userManager.fetchCurrentUser()
                await userManager.fetchUserStats()
            }
            
            group.addTask {
                await gridViewModel.refreshPosts()
            }
        }
    }
}

#Preview {
    CurrentUserProfileView()
}
