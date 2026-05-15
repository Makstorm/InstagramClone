//
//  FollowRequest.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.05.2026.
//

import Foundation

struct FollowRequest: Codable, Identifiable {
    let id: String
    let toUserId: String
    let fromUserId: String
    let timestamp: Date
    
    var user: User?
}
