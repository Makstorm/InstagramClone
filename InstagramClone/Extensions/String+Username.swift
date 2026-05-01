//
//  String+Username.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 27.04.2026.
//

import Foundation

extension String {
    func isValidUsername() -> Bool {
        let usernameRegex = "^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"
        
        let userPredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return userPredicate.evaluate(with: self)
    }
}

