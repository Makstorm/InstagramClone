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
    @Published var loadingState: ContentLoadingState = .loading
    
    private var isInitialLoad = true
    private var isFetching = false
    
    private let service: NotificationFetchingServiceProtocol
    private let userService: UserServiceProtocol
    private let followService: FollowServiceProtocol
    private let notificationManager: NotificationManager

    private var currentUser: User?
    
    init(service: NotificationFetchingServiceProtocol, userService: UserServiceProtocol, followService: FollowServiceProtocol, notificationManager: NotificationManager) {
        self.service = service
        self.userService = userService
        self.followService = followService
        self.notificationManager = notificationManager
        
        self.currentUser = nil
    }
    
    func fetchNotifications() async  {
        guard isInitialLoad else { return }
        
        await fetchAndUpdateNotifications()
        isInitialLoad.toggle()
    }
    
    func loadMoreNotifications() async {
        await fetchAndUpdateNotifications()
    }
    
    func refreshNotifications() async {
        guard !isFetching else { return }
        isFetching = true
        defer { isFetching = false }
        
        do {
            self.notifications.removeAll()
            loadingState = .loading
            
            let tempNotifications = try await service.refreshNotifications()
            try await updateNotifications(tempNotifications)
            
            loadingState = notifications.isEmpty ? .empty : .complete
        } catch {
            loadingState = .error
            print("DEBUG: Failed to refresh notifications with error \(error.localizedDescription)")
        }
    }
    
    private func fetchAndUpdateNotifications() async {
        guard !isFetching else { return }
        isFetching = true
        defer { isFetching = false }
        
        do {
            let tempNotificaions = try await service.fetchNotifications()
            try await self.updateNotifications(tempNotificaions)
            loadingState = notifications.isEmpty ? .empty : .complete
        } catch {
            loadingState = .error
            print("DEBUG: Failed to fetch notifications with error \(error.localizedDescription)")
        }
    }
    
    
    private func updateNotifications(_ notifications: [Notification]) async throws {
        var result = notifications
        
        try await withThrowingTaskGroup(of: (Int, Notification?).self) { [weak self] group in
            guard let self else { return }
            for (index, notification) in result.enumerated() {
                group.addTask {
                    do {
                        var updatedNotification = notification
                        
                        async let user = self.userService.fetchUser(withUid: notification.notificationSenderUid)
                        
                        async let relationState = notification.type == .follow ? self.followService.fetchUserRelatioState(
                            uid: notification.notificationSenderUid
                        ) : nil
                        
                        async let post = notification.postId != nil ? PostService.fetchPost(
                            notification.postId!
                        ) : nil
                        
                        updatedNotification.user = try await user
                        updatedNotification.post = try await post
                        updatedNotification.user?.userRelationState = try await relationState ?? .unknown
                        
                        return (index, updatedNotification)
                    } catch {
                        return (index, nil)
                    }
                }
            }
            
            for try await (index, notification) in group {
                guard let notification else { continue }
                result[index] = notification
            }
        }
        self.notifications.append(contentsOf: result)
    }
}

extension NotificationsViewModel {
    func follow(for notification: Notification, with index: Int?) {
        guard let index else { return }

        Task {
            let prevState = notifications[index].user?.userRelationState
            do {
                notifications[index].user?.userRelationState = .followed
                try await followService.follow(uid: notification.notificationSenderUid)
                try await notificationManager.uploadFollowNotification(toUid: notification.notificationSenderUid)
            } catch {
                notifications[index].user?.userRelationState = prevState ?? .unknown
            }
        }
    }
    
    func unfollow(for notification: Notification, with index: Int?) {
        guard let index else { return }
        
        Task {
            let prevState = notifications[index].user?.userRelationState
            do {
                notifications[index].user?.userRelationState = .notFollowed
                try await followService.unfollow(uid: notification.notificationSenderUid)
            } catch {
                notifications[index].user?.userRelationState = prevState ?? .unknown
            }
        }
    }
}
