//
//  AuthenticationRouterTests.swift
//  InstagramCloneTests
//
//  Created by Maxym Horobets on 29.04.2026.
//

import XCTest
@testable import InstagramClone

@MainActor
final class AuthenticationRouterTests: XCTestCase {
    
    var router: AuthenticationRouter!
    
    override func setUp() {
        super.setUp()
        router = AuthenticationRouter()
        
    }
    
    override func tearDown() {
        router = nil
        super.tearDown()
    }
    
    func testStartRegistration() {
        router.startRegistration()
        
        XCTAssertEqual(router.navigationPath.count, 1)
        XCTAssertEqual(router.navigationPath.first, RegistrationSteps(rawValue: 0))
    }
    
    func testNavigateToNextStep() {
        router.startRegistration()
        router.navigate()
        
        XCTAssertEqual(router.navigationPath.count, 2)
        XCTAssertEqual(router.navigationPath.last, RegistrationSteps(rawValue: 1))
    }
    
    func testNavigateToCompletion() {
        router.navigationPath.append(contentsOf: RegistrationSteps.allCases)
        
        XCTAssertEqual(router.navigationPath.count, RegistrationSteps.allCases.count)
        XCTAssertEqual(router.navigationPath.last, RegistrationSteps.completion)
    }
    
    func testNoNavigationBeyondCompletion() {
        router.navigationPath.append(contentsOf: RegistrationSteps.allCases)
        
        router.navigate()
        XCTAssertEqual(router.navigationPath.last, RegistrationSteps.completion)
        
    }
    
    func testResetRouter() {
        router.startRegistration()
        router.navigate()
        router.reset()
        
        XCTAssertTrue(router.navigationPath.isEmpty)
        XCTAssertNil(router.currentStep)
    }
    
    func testCurrentStepIsCorrectValue() {
        router.startRegistration()
        
        XCTAssertNotNil(router.currentStep)
        XCTAssertEqual(router.navigationPath.last, router.currentStep)
    }
    
    func testEmptyNavigationDoesNotCrashNavigation() {
        router.navigate()
        
        XCTAssertEqual(router.navigationPath.count, 0)
        XCTAssertNil(router.currentStep)
    }
}
