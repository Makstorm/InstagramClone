//
//  MockLikePostService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 09.05.2026.
//

import Foundation

class MockLikePostService: LikePostServiceProtocol {
    var didCallLikePost = false
    var didCallUnlikePost = false
    
    func likePost(_ post: Post) async throws {
        didCallLikePost = true
    }
    
    func unlikePost(_ post: Post) async throws {
        didCallUnlikePost = true
    }
    
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        return Bool.random()
    }
}
