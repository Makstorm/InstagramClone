//
//  SearchViewMode.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 20.04.2026.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task { try await fetchAllUsers() }
    }
    
    @MainActor
    func fetchAllUsers() async throws {
        self.users = try await UserService.fetchAllUsers()
    }
}
