//
//  LikesService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 08.05.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol LikePostServiceProtocol {
    func likePost(_ post: Post) async throws
    func unlikePost(_ post: Post) async throws
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool
}

struct LikePostService: LikePostServiceProtocol {
    private let cache = LikesCache()
    
    func likePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let postRef = FirebaseConstants.PostsCollection.document(post.id)
        let postLikesRef = postRef.collection("post-likes").document(uid)
        let userLikeRef = FirebaseConstants.UserLikesCollection(uid: uid).document(post.id)
        
        batch.setData([:], forDocument: postLikesRef)
        batch.setData([:], forDocument: userLikeRef)
        batch.updateData(["likes": FieldValue.increment(Int64(1))], forDocument: postRef)
        
        try await batch.commit()
        
        cache.update(post.id, didAdd: true)
    }
    
    func unlikePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let postRef = FirebaseConstants.PostsCollection.document(post.id)
        let postLikesRef = postRef.collection("post-likes").document(uid)
        let userLikeRef = FirebaseConstants.UserLikesCollection(uid: uid).document(post.id)
        
        batch.deleteDocument(postLikesRef)
        batch.deleteDocument(userLikeRef)
        batch.updateData(["likes": FieldValue.increment(Int64(-1))], forDocument: postRef)
        
        try await batch.commit()
        
        cache.update(post.id, didAdd: false)
    }
    
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        return cache.contains(post.id)
    }
}
