//
//  RegistrationValidationError.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 30.04.2026.
//

import Foundation

enum RegistrationValidationError: Error {
    case emailValidationFailed
    case usernameValidationFailed
    case invalidUsernameFormat
    case invalidEmailFormat
    case unknown
    case networkError
}

extension RegistrationValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emailValidationFailed: "This email is already in use. Please login or try again."
        case .invalidEmailFormat: "Email entered is invalid. Please try again. "
        case .invalidUsernameFormat: "Username format is invalid. Please try again."
        case .networkError: "A network error occured"
        case .unknown: "An unknown error occured. Please try again."
        case .usernameValidationFailed: "This username is already in use. Please try again."
        }
    }
}
