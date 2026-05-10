//
//  User.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import Foundation
import FirebaseAuth

struct User: Identifiable, Codable, Hashable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var fullname: String?
    var bio: String?
    let email: String
    
    var isFollowed: Bool? 
    var stats: UserStats?
    
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == id
    }
}

struct UserStats: Codable, Hashable {
    var followersCount: Int
    var followingCount: Int
    var postsCount: Int
}

extension User {
}
