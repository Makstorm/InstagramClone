//
//  AuthenticationRouter.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 27.04.2026.
//

import Foundation
import Combine

class AuthenticationRouter: ObservableObject {
    @Published var navigationPath = [RegistrationSteps]()
    
    private(set) var currentStep: RegistrationSteps?
    
    func startRegistration() {
        guard let initialStep = RegistrationSteps(rawValue: 0) else { return }
        navigationPath.append(initialStep)
        self.currentStep = initialStep
    }
    
    func navigate() {
        self.currentStep = navigationPath.last
        
        guard let index = currentStep?.rawValue else { return }
        guard let nextStep = RegistrationSteps(rawValue: index + 1) else { return }
        
        navigationPath.append(nextStep)
    }
    
    func reset() {
        navigationPath.removeAll()
        currentStep = nil
    }
}
