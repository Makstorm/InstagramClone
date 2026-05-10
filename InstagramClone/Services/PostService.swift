//
//  PostService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 20.04.2026.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth
import Foundation

struct PostService {
    // used in feed page to load posts

    static func fetchUserPosts(uid: String) async throws -> [Post] {
        let snapshot = try await FirebaseConstants.PostsCollection.whereField(
            "ownerUid",
            isEqualTo: uid
        ).getDocuments()
        let userPosts = try snapshot.documents.compactMap {
            return try $0.data(as: Post.self)
        }
        return userPosts
    }
    
    static func fetchPost(_ postId: String) async throws -> Post {
        return try await FirebaseConstants.PostsCollection.document(postId).getDocument(as: Post.self)
    }
}
