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
}
