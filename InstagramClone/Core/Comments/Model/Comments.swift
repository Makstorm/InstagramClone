//
//  Comments.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 22.04.2026.
//

import Foundation

struct Comment: Identifiable, Codable {
    let id: String 
    let postOwnerUid: String
    let commnetText: String
    let postId: String
    let timestamp: Date
    let commentOwnerUid: String
    
    var user: User? 
}
