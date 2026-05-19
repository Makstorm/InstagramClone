//
//  NotificationMangerService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 19.05.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol NotificationManagerServiceProtocol {
    func uploadNotification(toUid uid: String, type: NotificationType, post: Post?) async throws
    func deleteNotification(toUid uid: String, type: NotificationType, post: Post?) async throws
}

struct NotificationManagerService: NotificationManagerServiceProtocol {
    func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid, uid != currentUid else { return }

        let ref = FirebaseConstants.UserNotificationCollection(uid: uid)
            .document()
        let notification = Notification(
            id: ref.documentID,
            postId: post?.id,
            timestamp: Date(),
            notificationSenderUid: currentUid,
            type: type
        )

        guard let notificationData = try? Firestore.Encoder().encode(notification) else { return }

        try await ref.setData(notificationData)
    }

    func deleteNotification(toUid uid: String, type: NotificationType, post: Post? = nil) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        let snapshot = try await FirebaseConstants
            .UserNotificationCollection(uid: uid)
            .whereField("notificationSender", isEqualTo: currentUid)
            .getDocuments()
        let notifications = snapshot.documents.compactMap({ try? $0.data(as: Notification.self)})
        
        let filteredByType = notifications.filter({ $0.type == type }) // gets all notifications by type
        
        if type == .follow {
            for notification in filteredByType {
                try await FirebaseConstants
                    .UserNotificationCollection(uid: uid)
                    .document(notification.id)
                    .delete()
            }
        }
        
        guard let notificationToDelete = filteredByType.first(where: { $0.postId == post?.id }) else { return } // gets a notification to delete by post id
        
        try await FirebaseConstants
            .UserNotificationCollection(uid: uid).document(notificationToDelete.id)
            .delete()
    }
}
