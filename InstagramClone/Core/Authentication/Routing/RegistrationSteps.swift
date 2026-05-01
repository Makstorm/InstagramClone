//
//  RegistrationSteps.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 27.04.2026.
//

import Foundation

enum RegistrationSteps: Int, CaseIterable {
    case email
    case username
    case password
    case completion
}

extension RegistrationSteps: Identifiable, Hashable {
    var id: Int {
        return self.rawValue
    }
}
