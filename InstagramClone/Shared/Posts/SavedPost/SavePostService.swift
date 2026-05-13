//
//  SavePostService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 08.05.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol SavePostServiceProtocol {
    func save(_ post: Post) async throws
    func unsave(_ post: Post) async throws
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool
}

struct SavePostService: SavePostServiceProtocol {
    private let cache = SavedPostCache.shared
    
    func save(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await FirebaseConstants.UserSavedPostsCollection(uid: uid).document(post.id).setData([:])
        cache.update(post.id, didAdd: true)
    }
    
    func unsave(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await FirebaseConstants.UserSavedPostsCollection(uid: uid).document(post.id).delete()
        cache.update(post.id, didAdd: false)
    }
    
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        return cache.contains(post.id)
    }
}
