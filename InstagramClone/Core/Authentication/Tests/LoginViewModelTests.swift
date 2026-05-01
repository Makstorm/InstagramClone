//
//  LoginViewModelTests.swift
//  InstagramCloneTests
//
//  Created by Maxym Horobets on 29.04.2026.
//

import XCTest
@testable import InstagramClone

@MainActor
final class LoginViewModelTests: XCTestCase {
    var authManager: AuthManager!
    var mockService: MockAuthService!
    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockService = MockAuthService()
        authManager = AuthManager(service: mockService)
        viewModel = LoginViewModel()
    }
    
    override func tearDown() {
        mockService = nil
        authManager = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.error, nil)
        XCTAssertEqual(viewModel.showError, false)
    }
    
    func testLoginSuccess() async {
        viewModel.email = "test@gmail.com"
        viewModel.password = "123456"
        
        await viewModel.logIn(with: authManager)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testLoginFailure() async {
        mockService.errorToThrow = AuthenticationError.unknown
        
        viewModel.email = "test@gmail.com"
        viewModel.password = "qqqqqq"
        
        await viewModel.logIn(with: authManager)
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.error)
    }
}
