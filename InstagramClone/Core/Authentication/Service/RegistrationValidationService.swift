//
//  RegistrationValidationService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 30.04.2026.
//

import FirebaseFirestore
import Foundation

protocol RegistrationValidationProtocol {
    func validateEmail(_ email: String) async throws -> Bool
    func validateUsername(_ username: String) async throws -> Bool
}

struct RegistrationValidationService: RegistrationValidationProtocol {
    func validateEmail(_ email: String) async throws -> Bool {
      
        let isUnique = try await checkUniqueness(forKey: "email", value: email)
        
        if !isUnique {
            throw RegistrationValidationError.emailValidationFailed
        }
        
        return isUnique
    }

    func validateUsername(_ username: String) async throws -> Bool {
       let isUnique = try await checkUniqueness(forKey: "username", value: username)
        
        if !isUnique {
            throw RegistrationValidationError.emailValidationFailed
        }
        
        return isUnique
    }
    
    private func checkUniqueness(forKey key: String, value: String) async throws -> Bool {
        let snapshot = try await FirebaseConstants
            .UserCollection
            .whereField(key, isEqualTo: value)
            .limit(to: 1)
            .getDocuments()

        return snapshot.isEmpty
    }
}

class MockRegistrationValidationService: RegistrationValidationProtocol {
    func validateEmail(_ email: String) async throws -> Bool {
        return email.isValidEmail()
    }

    func validateUsername(_ username: String) async throws -> Bool {
        return username.isValidUsername()
    }
}
