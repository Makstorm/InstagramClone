//
//  DeveloperPreview.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 22.04.2026.
//

import Firebase
import SwiftUI

class DeveloperPreview {
    static let shared = DeveloperPreview()

    let comment = Comment(
        id: NSUUID().uuidString,
        postOwnerUid: "123",
        commnetText: "test comment for now",
        postId: "3213",
        timestamp: Date(),
        commentOwnerUid: "454554"
    )

    let notifications: [Notification] = [
        .init(
            id: NSUUID().uuidString,
            timestamp: Date(),
            notificationSenderUid: "123",
            type: .like
        ),
        .init(
            id: NSUUID().uuidString,
            timestamp: Date(),
            notificationSenderUid: "456",
            type: .comment
        ),
        .init(
            id: NSUUID().uuidString,
            timestamp: Date(),
            notificationSenderUid: "789",
            type: .follow
        ),
        .init(
            id: NSUUID().uuidString,
            timestamp: Date(),
            notificationSenderUid: "012",
            type: .like
        ),
    ]
}
