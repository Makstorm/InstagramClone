//
//  AuthenticationError.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 27.04.2026.
//

import Foundation

enum AuthenticationError: Error {
    case userDisabled
    case emailAlreadyInUse
    case invalidEmail
    case wrongPassword
    case userNotFound
    case networkError
    case credentialAlreadyInUse
    case werkPassword
    case unknown
    case invalidCredentials
    case tooManyRequests
    
    init(rawValue: Int) {
        switch rawValue {
        case 17004: self = .invalidCredentials
        case 17005: self = .userDisabled
        case 17007: self = .emailAlreadyInUse
        case 17008: self = .invalidEmail
        case 17009: self = .wrongPassword
        case 17010: self = .tooManyRequests
        case 17011: self = .userNotFound
        case 17020: self = .networkError
        case 17025: self = .credentialAlreadyInUse
        case 17026: self = .werkPassword
        default: self = .unknown
        }
    }
}

extension AuthenticationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .userDisabled:
            return "This account has been disabled."
        case .emailAlreadyInUse:
            return "This email is alredy in use. Please login or try again."
        case .invalidEmail:
            return "The email addres is invalid. Please try again later."
        case .wrongPassword:
            return "Inkorrect password. Please try again."
        case .userNotFound:
            return "There is no account assosiated with this credentials. Please try again."
        case .networkError:
            return "A network error ocurred. Please try again laster."
        case .credentialAlreadyInUse:
            return "Credentials already in use. Please try again."
        case .werkPassword:
            return "Password must be at least 6 characters in length. Please try again."
        case .unknown:
            return "An unknown error occurred. Please try again."
        case .invalidCredentials:
            return "The credentiald you entered are invalid. Please try again."
        case .tooManyRequests:
            return "Access to this accout has been temporarily disabled due to multiple failed login attempts. Please try again later."
        }
    }
}
