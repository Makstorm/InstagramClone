//
//  AuthManagerTests.swift
//  InstagramCloneTests
//
//  Created by Maxym Horobets on 29.04.2026.
//

import XCTest
@testable import InstagramClone

@MainActor
final class AuthManagerTests: XCTestCase {
    var mockService: MockAuthService!
    var authManager: AuthManager!
    
    override func setUp() {
        super.setUp()
        mockService = MockAuthService()
        authManager = AuthManager(service: mockService)
    }
    
    override func tearDown() {
        mockService = nil
        authManager = nil
        super.tearDown()
    }
    
    func testLoginSuccess() async {
        try? await authManager.login(withEmail: "test@gmail.com", password: "qqqqqq")
        XCTAssertNotNil(authManager.userSession)
    }
    func testLoginFailure() async {
        authManager.userSession = nil
        mockService.errorToThrow = .unknown
        
        try? await authManager.login(withEmail: "test@gmail.com", password: "qqqqqq")
        XCTAssertNil(authManager.userSession)
    }
    
    func testLoginWithInvalidEmail() async {
        authManager.userSession = nil
        
        try? await authManager.login(withEmail: "test.com", password: "qqqqqqqq")
    }
    
    func testLoginWithInvalidPassword() async {
        authManager.userSession = nil
        
        try? await authManager.login(withEmail: "test@gmail.com", password: "qqq")
        XCTAssertNil(authManager.userSession)
    }
    
    func testCreateUserSuccess() async {
        try? await authManager.createUser(withEmail: "test@gmail.com", password: "qqqqqq", username: "pt4shk4")
        
        XCTAssertNotNil(authManager.userSession)
    }
    
    func testCreateUserFailure() async {
        authManager.userSession = nil
        mockService.errorToThrow = .credentialAlreadyInUse
        
        try? await authManager.createUser(withEmail: "test@gmail.com", password: "qqqqqq", username: "pt4shk4")
        XCTAssertNil(authManager.userSession)
    }
    
    func testCreateUserFailureWithInvalidUsername() async {
        authManager.userSession = nil
        
        try? await authManager.createUser(withEmail: "test@gmail.com", password: "qqqqqq", username: "!@$@$@$!hakjfhafh*&^%")
        
        XCTAssertNil(authManager.userSession)
    }
    
    func testSignOut() async {
        authManager.signOut()
        XCTAssertNil(authManager.userSession)
        XCTAssertTrue(mockService.didCallSignOut)
    }
    
    func testDeleteAccountSuccess() async throws {
        try await authManager.deleteAccount()
        XCTAssertTrue(mockService.didCallDeleteAccount)
    }
    func testSendResetPasswordLink() async throws {
        try await authManager.sendResetPasswordLink(toEmail: "test2@gmail.com")
        XCTAssertTrue(mockService.didCallSendeRessetPasswordLink)
    }
}
