//
//  MockUserService 2.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 29.04.2026.
//


struct MockUserService: UserServiceProtocol {
    func fetchCurrentUser() async throws -> User? {
        return nil
    }
}