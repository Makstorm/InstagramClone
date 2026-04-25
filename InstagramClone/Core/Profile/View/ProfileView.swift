//
//  ProfileView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User

    var body: some View {
        ScrollView {
            // header
            ProfileHeaderView(user: user)
            // posts

            PostGridView(user: user)

        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(user: User.MOCK_USERS[1])
}
