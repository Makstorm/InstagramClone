//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 23.04.2026.
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    
    private let followService: FollowServiceProtocol
    private let notificationManager: NotificationManager
    
    init(user: User, followService: FollowServiceProtocol, notificationManager: NotificationManager) {
        self.user = user
        self.followService = followService
        self.notificationManager = notificationManager
    }
    
    func fetchUserStats() async {
        guard user.stats == nil else { return }
        do {
            self.user.stats = try await UserService.fetchUserStats(uid: user.id)
        } catch {
            print("DEBUG: Failed to fetch user stats from ProfileView with error: \(error.localizedDescription)")
        }
    }
}

extension ProfileViewModel {
    func follow() {
        Task {
            let prevState = user.userRelationState
            do {
                user.userRelationState = .followed
                try await followService.follow(uid: user.id)
                try await notificationManager.uploadFollowNotification(toUid: user.id)
            } catch {
                user.userRelationState = prevState
            }
        }
    }
    
    func unfollow() {
        Task {
            let prevState = user.userRelationState
            do {
                user.userRelationState = .notFollowed
                try await followService.unfollow(uid: user.id)
                await notificationManager.deleteFollowNotification(notificationOwnerUid: user.id)
            } catch {
                user.userRelationState = prevState
            }
        }
    }
    
    func fetchUserRelationState() async {
        guard user.userRelationState == .unknown else { return }
        
        do {
            self.user.userRelationState = try await followService.fetchUserRelatioState(uid: user.id)
        } catch {
            print("DEBUG: Failed to check if user is followed with error: \(error.localizedDescription)")
        }
    }
    
    func sendFollowRequest() {
        Task {
            let prevState = user.userRelationState
            
            do {
                user.userRelationState = .requestedToFollow
                try await followService.sendFollowRequest(to: user.id)
            } catch {
                user.userRelationState = prevState
                print("DEBUG: Failed to send a follow request with error: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFollowRequest() {
        Task {
            let prevState = user.userRelationState
            
            do {
                user.userRelationState = .notFollowed
                try await followService.removeFollowRequest(to: user.id)
            } catch {
                user.userRelationState = prevState
                print("DEBUG: Failed to remove a follow request with error: \(error.localizedDescription)")
            }
        }
    }
}
