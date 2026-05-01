//
//  MockAuthService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 29.04.2026.
//

import Foundation

class MockAuthService: AuthServiceProtocol {
    
    var errorToThrow: AuthenticationError?
    var didCallSignOut = false
    var didCallSendeRessetPasswordLink = false
    var didCallDeleteAccount = false
    
    func createUser(withEmail email: String, password: String, username: String) async throws -> String {
        if !email.isValidEmail() { throw AuthenticationError.invalidEmail }
        if !password.isValidPassword() { throw AuthenticationError.invalidCredentials }
        if !username.isValidUsername() { throw AuthenticationError.invalidCredentials }
        if let errorToThrow { throw errorToThrow }
        
        return UUID().uuidString
    }
    
    func deleteAccount() async throws {
        didCallDeleteAccount = true
    }
    
    func getUserSession() -> String? {
        return ""
    }
    
    func login(withEmail email: String, password: String) async throws -> String {
        if !email.isValidEmail() { throw AuthenticationError.invalidEmail }
        if !password.isValidPassword() { throw AuthenticationError.invalidCredentials }
        if let errorToThrow { throw errorToThrow }
        return UUID().uuidString
    }
    
    func signout() {
        didCallSignOut = true 
    }
    
    func sendRessetPasswordLink(toEmail email: String) async throws {
        didCallSendeRessetPasswordLink = true
    }
}
