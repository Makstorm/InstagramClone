//
//  registrationViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 18.04.2026.
//

import Foundation
import Combine

@MainActor
class RegistrationViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var isValidating = false
    
    @Published var showError = false
    @Published var validationError: RegistrationValidationError?
    @Published var authError: AuthenticationError? {
        didSet {
            showError = authError != nil
        }
    }
    
    private let service: RegistrationValidationProtocol
    
    init(service: RegistrationValidationProtocol) {
        self.service = service
    }
    
    func createUser(with authManager: AuthManager) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await authManager.createUser(withEmail: email, password: password, username: username)
            self.resset()
        } catch {
            self.authError = error as? AuthenticationError ?? .unknown 
        }
    }
    
    func validateEmail() async -> Bool {
        isValidating = true
        defer { isValidating = false }
        do {
            return try await service.validateEmail(email)
        } catch  {
            self.validationError = error as? RegistrationValidationError ?? .unknown
            return false
        }
    }
    
    func validateUsername() async -> Bool {
        isValidating = true
        defer { isValidating = false }
        do {
            return try await service.validateUsername(username)
        } catch  {
            self.validationError = error as? RegistrationValidationError ?? .unknown
            return false
        }
    }

    func resset() {
        username = ""
        email = ""
        password = ""
    }
}
