//
//  MockUserService 2.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 29.04.2026.
//

import Foundation

struct MockUserService: UserServiceProtocol {
    func fetchUser(withUid uId: String) async throws -> User {
        return User(id: MockData.users[0].id, username: "Maks", email: "maks@gmail.com", isPrivate: true)
    }
    
    func fetchCurrentUser() async throws -> User? {
        return User(id: MockData.users[0].id, username: "Maks", email: "maks@gmail.com", isPrivate: true)
    }
    
    func updateUserAccountPrivacy(_ isPrivate: Bool) async throws {
        MockData.users[0].isPrivate.toggle()
    }
}
