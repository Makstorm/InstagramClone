//
//  MockUserService 2.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 29.04.2026.
//

import Foundation

struct MockUserService: UserServiceProtocol {
    func fetchUser(withUid uId: String) async throws -> User {
        return User(id: NSUUID().uuidString, username: "Maks", email: "maks@gmail.com")
    }
    
    func fetchCurrentUser() async throws -> User? {
        return nil
    }
}
