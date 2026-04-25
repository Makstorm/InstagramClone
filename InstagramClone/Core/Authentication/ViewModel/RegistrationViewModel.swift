//
//  registrationViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 18.04.2026.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    func createUser() async throws {
        try await AuthService.shared.createUser(email: email, password: password, username: username)
        
        username = ""
        email = ""
        password = "" 
    }
}
