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
    
    init(user: User) {
        self.user = user
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
            try await UserService.follow(uid: user.id)
            user.isFollowed = true
            
            NotificationManager.shared.uploadFollowNotification(toUid: user.id)
        }
    }
    
    func unfollow() {
        Task {
            try await UserService.unfollow(uid: user.id)
            user.isFollowed = false
                
            await NotificationManager.shared.deleteFollowNotification(notificationOwnerUid: user.id)
        }
    }
    
    func checkIfUserIsFollowed() async {
        guard user.isFollowed == nil else { return }
        
        do {
            self.user.isFollowed = try await UserService.checkIfUserIsFollowed(uid: user.id)
        } catch {
            print("DEBUG: Failed to check if user is followed with error: \(error.localizedDescription)")
        }
    }
}
