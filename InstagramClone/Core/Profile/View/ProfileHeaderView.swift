//
//  ProfileHeaderView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import SwiftUI

struct ProfileHeaderView: View {
    private let user: User
    private let actionHandler: () -> Void
        
    init(user: User, actionHandler: @escaping () -> Void) {
        self.user = user
        self.actionHandler = actionHandler
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // pict and stats
            HStack {                
                CircularProfileImageView(user: user, size: .large)

                Spacer()

                HStack(spacing: 8) {
                    UserStatView(title: "Post", value: stats.postsCount)
                    NavigationLink(value: UserListConfiguration.followers(uid: user.id)) {
                        UserStatView(title: "Followers", value: stats.followersCount)
                    }
                    NavigationLink(value: UserListConfiguration.following(uid: user.id)) {
                        UserStatView(title: "Following", value: stats.followingCount)
                    }
                }
            }
            .padding(.horizontal)

            // name and bio
            VStack(alignment: .leading, spacing: 4) {
                if let fullname = user.fullname {
                    Text(fullname)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }

                if let bio = user.bio {
                    Text(bio)
                        .font(.footnote)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            // action button

            Button { actionHandler() } label: {
                Text(buttonTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360, height: 32)
                    .background(buttonBackground)
                    .foregroundStyle(buttonForegroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(buttonBorderColor, lineWidth: 1)
                    )
            }
            .disabled(user.userRelationState == .unknown)

            Divider()
        }
        .navigationDestination(for: UserListConfiguration.self, destination: { config in
            UserListView(config: config)
        })
    }
}

private extension ProfileHeaderView {
    private var isFollowed: Bool {
        return user.userRelationState == .followed
    }
    
    private var stats: UserStats {
        return user.stats ?? .init(followersCount: 0, followingCount: 0, postsCount: 0)
    }
    
    private var buttonTitle: String {
        switch user.userRelationState {
        case .unknown: "Loading..."
        case .isCurrentUser: "Edit Profile"
        case .notFollowed: "Follow"
        case .followed: "Following"
        case .requestedToFollow: "Requested"
        case .blocked: "Blocked"
        }
    }
    
    private var buttonBackground: Color {
        switch user.userRelationState {
        case .notFollowed: .blue
        default: .white
        }
    }
    
    private var buttonForegroundColor: Color {
        switch user.userRelationState {
        case .notFollowed: .white
        default: .black
        }
    }
    
    private var buttonBorderColor: Color {
        switch user.userRelationState {
        case .notFollowed: .clear
        default: .gray
        }
    }
}

#Preview {
    ProfileHeaderView(user: MockData.users[0]) { }
}
