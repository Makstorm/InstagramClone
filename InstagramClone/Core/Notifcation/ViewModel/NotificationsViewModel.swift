//
//  NotificationsViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import Foundation
import Combine

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var notifications = [Notification]()
   
    private let service: NotificationService
    private var currentUser: User?
    
    init(service: NotificationService) {
        self.service = service
        Task { await fetchNotifications() }
        self.currentUser = UserService.shared.currentUser
    }
    
    func fetchNotifications() async  {
        do {
            self.notifications = try await service.fetchNotifications()
            try await self.updateNotifications()
        } catch {
            print("DEBUG: Failed to fetch notifications with error \(error.localizedDescription)")
        }
    }
    
    
    private func updateNotifications() async throws {
        for i in 0 ..< notifications.count {
            var notification = notifications[i]
            
            notification.user = try await UserService.fetchUser(withUid: notification.notificationSenderUid)
            
            if let postId = notification.postId {
                notification.post = try await PostService.fetchPost(postId)
                notification.post?.user = self.currentUser
            }
            
            notifications[i] = notification
        }
    }
}
