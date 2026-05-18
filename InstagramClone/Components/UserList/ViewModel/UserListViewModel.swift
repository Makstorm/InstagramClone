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
    @Published var loadingState: ContentLoadingState = .loading
    
    private let service: UserListService
    
    init(service: UserListService) {
        self.service = service
    }
    
    func fetchUser(forConfig config: UserListConfiguration) async {
        do {
            let data = try await service.fetchUsers(forConfig: config)
            users.append(contentsOf: data)
            self.loadingState = users.isEmpty ? .empty : .complete
        } catch {
            self.loadingState = .error
            print("DEBUG: Failed to fetch users with error \(error.localizedDescription)")
        }
    }
}

