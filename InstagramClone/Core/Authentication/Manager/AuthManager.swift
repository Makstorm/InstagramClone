//
//  AuthManager.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 26.04.2026.
//

import Combine

// this class is responsible for state management
@MainActor
class AuthManager: ObservableObject {
    private let service: AuthServiceProtocol

    @Published var userSession: String?

    init(service: AuthServiceProtocol) {
        self.service = service
        self.userSession = service.getUserSession()
    }

    func login(withEmail email: String, password: String) async throws {
        self.userSession = try await service.login(
            withEmail: email,
            password: password
        )
    }

    func createUser(withEmail email: String, password: String, username: String) async throws {
        self.userSession = try await service
            .createUser(
                withEmail: email,
                password: password,
                username: username
            )
    }

    func deleteAccount() async throws {
        try await self.service.deleteAccount()
        
    }

    func sendResetPasswordLink(toEmail email: String) async throws {
        try await service.sendRessetPasswordLink(toEmail: email)
    }
    
    func signOut() {
        service.signout()  // signs out on backend
        userSession = nil  // signs out on client

    }
}
