//
//  NotificationManage.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import Foundation

class NotificationManager {
    static let shared = NotificationManager()
    private let service = NotificationService()
    
    private init() {}
    
    func uploadLikeNotification(toUid uid: String, post: Post) {
        service.uploadNotification(toUid: uid, type: .like, post: post)
    }
    
    func uploadCommentNotification(toUid uid: String, post: Post) {
        service.uploadNotification(toUid: uid, type: .comment, post: post)
    }
    
    func uploadFollowNotification(toUid uid: String) {
        service.uploadNotification(toUid: uid, type: .follow)
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
            try await service.deleteNotification(toUid: notificationOwnerUid, type: .follow)
        } catch {
           print("DEBUG: Failed to delete follow notification")
        }
    }
}
