//
//  Notification.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import Foundation
import Firebase

struct Notification: Codable, Identifiable {
    let id: String
    var postId: String?
    let timestamp: Timestamp
    let notificationSenderUid: String
    let type: NotificationType
    
    var post: Post?
    var user: User? 
}
