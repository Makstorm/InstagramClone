//
//  NotificationManage.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import Foundation

struct NotificationManager {
    private let service: NotificationManagerServiceProtocol
    
    init(service: NotificationManagerServiceProtocol) {
        self.service = service
    }
    
    func uploadLikeNotification(toUid uid: String, post: Post) async throws {
        try await service.uploadNotification(toUid: uid, type: .like, post: post)
    }
    
    func uploadCommentNotification(toUid uid: String, post: Post) async throws {
        try await service.uploadNotification(toUid: uid, type: .comment, post: post)
    }
    
    func uploadFollowNotification(toUid uid: String) async throws {
        try await service.uploadNotification(toUid: uid, type: .follow, post: nil)
    }
    
    func uploadFollowAcceptedNotification(toUid uid: String) async throws {
        try await service.uploadNotification(toUid: uid, type: .followRequestAccepted, post: nil)
    }
    
    func deleteLikeNotification(notificationOwnerUid uid: String, post: Post) async {
        do {
            try await service.deleteNotification(toUid: uid, type: .like, post: post)
        } catch {
            print("DEBUG: Failed deleting like notification with error \(error.localizedDescription)")
        }
    }
    
    func deleteFollowNotification(notificationOwnerUid: String) async {
        do {
            try await service.deleteNotification(toUid: notificationOwnerUid, type: .follow, post: nil)
        } catch {
           print("DEBUG: Failed to delete follow notification")
        }
    }
}
