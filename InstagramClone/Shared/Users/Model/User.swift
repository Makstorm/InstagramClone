//
//  User.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var fullname: String?
    var bio: String?
    let email: String
    var isPrivate: Bool
    var stats: UserStats?

    var userRelationState: UserRelationState = .unknown
    
    var isCurrentUser: Bool {
        userRelationState == .isCurrentUser
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl)
        self.fullname = try container.decodeIfPresent(String.self, forKey: .fullname)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.email = try container.decode(String.self, forKey: .email)
        self.isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        self.userRelationState = try container.decodeIfPresent(UserRelationState.self, forKey: .userRelationState) ?? .unknown
        self.stats = try container.decodeIfPresent(UserStats.self, forKey: .stats)
    }
    
    init(
        id: String,
        username: String,
        profileImageUrl: String? = nil,
        fullname: String? = nil,
        bio: String? = nil,
        email: String,
        isPrivate: Bool,
        userRelationState: UserRelationState? = nil,
        stats: UserStats? = nil
    ) {
        self.id = id
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.fullname = fullname
        self.bio = bio
        self.email = email
        self.isPrivate = isPrivate
        self.userRelationState = userRelationState ?? .unknown
        self.stats = stats
    }
}

struct UserStats: Codable, Hashable {
    var followersCount: Int
    var followingCount: Int
    var postsCount: Int
}

extension User {
}
