//
//  LoginViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 19.04.2026.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    
    @Published var showError = false
    @Published var error: AuthenticationError? {
        didSet {
            showError = error != nil
        }
    }
    
    func logIn(with authManager: AuthManager) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await authManager.login(withEmail: email, password: password)
        } catch let error as AuthenticationError {
            self.error = error
        } catch {
            self.error = .unknown
        }
    }
}
