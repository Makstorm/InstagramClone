//
//  MockSavePostService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 09.05.2026.
//

import Foundation

class MockSavePostService: SavePostServiceProtocol {
    var didCallSavePost = false
    var didCallUnsavePost = false
    
    func save(_ post: Post) async throws {
        didCallSavePost = true
    }
    
    func unsave(_ post: Post) async throws {
        didCallUnsavePost = true
    }
    
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        return Bool.random()
    }
}
