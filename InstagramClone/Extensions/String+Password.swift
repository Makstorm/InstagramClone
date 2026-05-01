//
//  Strinf+Password.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 27.04.2026.
//

import Foundation

extension String {
    func isValidPassword() -> Bool {
        return self.count > 5
    }
}
