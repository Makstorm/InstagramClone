//
//  ProfilePostGridService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 10.05.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfilePostGridService: PostGridServiceProtocol {
    private let user: User?
    
    private let fetchLimit = 21
    private var shouldLoadMoreData = true
    private var lastDoc: QueryDocumentSnapshot?

    init(user: User? = nil) {
        self.user = user
    }

    func fetchPosts() async throws -> [Post] {
        guard let uid = getUserId() else { return [] }
        
        let query = FirebaseConstants
            .PostsCollection
            .whereField("ownerUid", isEqualTo: uid)
            .limit(to: fetchLimit)
        
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
        } else {
            snapshot = try await query.getDocuments()
            lastDoc = snapshot.documents.last
        }
        
        var posts = snapshot.documents.compactMap { try? $0.data(as: Post.self) }
        
        for i in 0 ..< posts.count {
            posts[i].user = self.user
        }
        
        shouldLoadMoreData = posts.count == fetchLimit
        
        return posts
    }
    
    private func getUserId() -> String? {
        if let user {
            return user.id
        } else {
            guard let currentUid = Auth.auth().currentUser?.uid else { return nil }
            return currentUid
        }
    }
}
