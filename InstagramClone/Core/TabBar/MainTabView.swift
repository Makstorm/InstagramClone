//
//  MainTabView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        CustomTabBarContainer(tabs: [
            TabItem(icon: "house.fill") {
                FeedView()
            },
            TabItem(icon: "magnifyingglass") {
                SearchView()
            },
            TabItem(icon: "plus.square") {
                UploadPostView()
            },
            TabItem(icon: "heart") {
                NotificationView()
            },
            TabItem(icon: "person") {
                CurrentUserProfileView()
            }
        ])
    }
}

#Preview {
    MainTabView()
}

