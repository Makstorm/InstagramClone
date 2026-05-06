//
//  NotificationsService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class NotificationService {
    func fetchNotifications() async throws -> [Notification] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }

        let snapshot = try await FirebaseConstants.UserNotificationCollection(
            uid: currentUid
        )
            .order(by: "timestamp", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap({
            try? $0.data(as: Notification.self)
        })
    }

    func uploadNotification(
        toUid uid: String,
        type: NotificationType,
        post: Post? = nil
    ) {
        guard let currentUid = Auth.auth().currentUser?.uid, uid != currentUid
        else { return }

        let ref = FirebaseConstants.UserNotificationCollection(uid: uid)
            .document()
        let notification = Notification(
            id: ref.documentID,
            postId: post?.id,
            timestamp: Date(),
            notificationSenderUid: currentUid,
            type: type
        )

        guard
            let notificationData = try? Firestore.Encoder().encode(notification)
        else { return }

        ref.setData(notificationData)
    }

    func deleteNotification(
        toUid uid: String,
        type: NotificationType,
        post: Post? = nil
    ) async throws {
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
