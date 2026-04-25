//
//  DeveloperPreview.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 22.04.2026.
//

import SwiftUI
import Firebase

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let comment = Comment(postOwnerUid: "123", commnetText: "test comment for now", postId: "3213", timestamp: Timestamp(), commentOwnerUid: "454554")
    
    let notifications: [Notification] = [
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "123", type: .like),
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "456", type: .comment),
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "789", type: .follow),
        .init(id: NSUUID().uuidString, timestamp: Timestamp(), notificationSenderUid: "012", type: .like),
    ]
}
