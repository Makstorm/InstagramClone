//
//  LoginViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 19.04.2026.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
         try await AuthService.shared.login(withEmail: email, password: password)
    }
}
