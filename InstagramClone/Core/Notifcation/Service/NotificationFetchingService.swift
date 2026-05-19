//
//  NotificationsService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

protocol NotificationFetchingServiceProtocol {
    func fetchNotifications() async throws -> [Notification]
    func refreshNotifications() async throws -> [Notification]
}

class NotificationFetchingService: NotificationFetchingServiceProtocol {
    private let fetchLimit = 20
    private var shouldLoadMoreData = true
    private var lastDoc: QueryDocumentSnapshot?

    func fetchNotifications() async throws -> [Notification] {
        guard let currentUid = Auth.auth().currentUser?.uid, shouldLoadMoreData else { return [] }

        var query = FirebaseConstants
            .UserNotificationCollection(uid: currentUid)
            .order(by: "timestamp", descending: true)
            .limit(to: fetchLimit)

        if let lastDoc {
            query = query.start(afterDocument: lastDoc)
        }

        let snapshot = try await query.getDocuments()

        if let last = snapshot.documents.last {
            self.lastDoc = last
        }

        shouldLoadMoreData = snapshot.documents.count == fetchLimit

        return snapshot.documents.compactMap {
            try? $0.data(as: Notification.self)
        }
    }
    
    func refreshNotifications() async throws -> [Notification] {
        lastDoc = nil
        shouldLoadMoreData = true
        return try await fetchNotifications()
    }
}

