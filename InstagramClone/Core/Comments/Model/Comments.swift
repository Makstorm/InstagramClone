//
//  Comments.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 22.04.2026.
//

import Foundation
import FirebaseFirestore

struct Comment: Identifiable, Codable {
    @DocumentID var commentId: String?
    let postOwnerUid: String
    let commnetText: String
    let postId: String
    let timestamp: Timestamp
    let commentOwnerUid: String
    
    var user: User? 
    
    var id: String {
        return commentId ?? NSUUID().uuidString
    }
    
}
