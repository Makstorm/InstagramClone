//
//  RegistrationViewModelTests.swift
//  InstagramCloneTests
//
//  Created by Maxym Horobets on 29.04.2026.
//

import XCTest
@testable import InstagramClone

@MainActor
final class RegistrationViewModelTests: XCTestCase {
    var authManager: AuthManager!
    var mockService: MockAuthService!
    var viewModel: RegistrationViewModel!
    var mockValodationService: MockRegistrationValidationService!
    
    override func setUp() {
        super.setUp()
        
        mockService = MockAuthService()
        mockValodationService = MockRegistrationValidationService()
        authManager = AuthManager(service: mockService)
        viewModel = RegistrationViewModel(service: mockValodationService)
    }
    
    override func tearDown() {
        mockService = nil
        authManager = nil
        viewModel = nil
        mockValodationService = nil
        
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.username, "")
        XCTAssertEqual(viewModel.showError, false)
        XCTAssertEqual(viewModel.authError, nil)
    }
    
    func testReset() {
        viewModel.email = "test@gmail.com"
        viewModel.password = "qqqqqq"
        viewModel.username = "pt4shk4"
        
        viewModel.resset()
        
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.username, "")
    }
    
    func testCreateUserSuccess() async {
        viewModel.email = "test@gmail.com"
        viewModel.password = "qqqqqq"
        viewModel.username = "pt4shk4"
        
        await viewModel.createUser(with: authManager)
        
        XCTAssertNil(viewModel.authError)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.username, "")
    }
    
    func testCreateUserFailure() async {
        viewModel.email = "testgmail.com"
        viewModel.password = "qqqqqq"
        viewModel.username = "pt4shk4"

        await viewModel.createUser(with: authManager)
        
        XCTAssertNotNil(viewModel.authError)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testEmailValidationSuccess() async throws {
        viewModel.email = "test123@gmail.com"
        let isValid = await viewModel.validateEmail()
        XCTAssertTrue(isValid)
    }
    
    func testValidateEmailFailure() async throws {
        viewModel.email = "test123gmail.com"
            let isValid = await viewModel.validateEmail()
            XCTAssertFalse(isValid)
    }
    
    func testValidateUsernameSuccess() async {
        viewModel.username = "test"
            let isValid = await viewModel.validateUsername()
            XCTAssertTrue(isValid)
    }
    
    func testValidateUsernameFailure() async throws {
        viewModel.username = "tst!!!!!!"
        let isValid = await viewModel.validateUsername()
        XCTAssertFalse(isValid)
    }

}
