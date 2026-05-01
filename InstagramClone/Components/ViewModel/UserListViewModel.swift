//
//  UserListViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 23.04.2026.
//

import Foundation
import Combine

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users = [User]()
    
    func fetchUser(forConfig config: UserListConfig) async {
        do {
            self.users = try await UserService.fetchUsers(forConfig: config)
        } catch {
            print("DEBUG: Failed to fetch users with error \(error.localizedDescription)")
        }
    }
}

