//
//  UserListConfiguration.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 23.04.2026.
//

import Foundation

enum UserListConfiguration: Hashable {
    case followers(uid: String)
    case following(uid: String)
    case likes(postId: String)
    case explore

    var navigationTitle: String {
        switch self {
        case .followers: return "Followers"
        case .following: return "Following"
        case .likes: return "Likes"
        case .explore: return "Explore"
        }
    }
}
