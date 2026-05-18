//
//  FeedRouter.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 06.05.2026.
//

import SwiftUI

enum FeedRouter: Hashable {
    case inbox
    case profile(User)
    case postLikes(postId: String)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .inbox:
            Text("Inbox view")
        case .profile(let user):
            ProfileView(user: user)
        case .postLikes(postId: let postId):
            UserListView(config: .likes(postId: postId))
        }
    }
}
