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
    static func fetchPost(_ postId: String) async throws -> Post {
        return try await FirebaseConstants.PostsCollection.document(postId).getDocument(as: Post.self)
    }
}
