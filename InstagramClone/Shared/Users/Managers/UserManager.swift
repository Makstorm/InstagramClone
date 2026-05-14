//
//  UserManager.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 26.04.2026.
//

import Foundation
import Combine

@MainActor
class UserManager: ObservableObject {
    @Published var currentUser: User?
    
    private let service: UserServiceProtocol
    
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
    func fetchCurrentUser() async {
        do {
            self.currentUser = try await service.fetchCurrentUser()
        } catch  {
            print("DEBUG: Error fetching current user: \(error.localizedDescription)")
        }
        
    }
    
    func fetchUserStats() async {
        guard let uid = currentUser?.id, currentUser?.stats == nil else { return }
        do {
            self.currentUser?.stats = try await UserService.fetchUserStats(uid: uid)
        } catch {
            print("DEBUG: Failed to fetch current user stats with error: \(error.localizedDescription)")
        }
    }
    
    func updateAccountPrivacy(_ isPrivate: Bool) async {
        do {
            self.currentUser?.isPrivate = isPrivate
            try await service.updateUserAccountPrivacy(isPrivate)
        } catch {
            self.currentUser?.isPrivate.toggle()
            print("DEBUG: Failed to update user privacy with error: \(error.localizedDescription)")
        }
    }
}
