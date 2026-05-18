//
//  UserRelationState.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.05.2026.
//

import Foundation

enum UserRelationState: Codable {
    case unknown
    case isCurrentUser
    case notFollowed
    case followed
    case requestedToFollow
    case blocked
}
