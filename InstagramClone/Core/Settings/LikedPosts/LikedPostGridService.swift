//
//  LikedPostGridService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 11.05.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LikedPostGridService: PostGridServiceProtocol {
    private let fetchLimit = 21
    private var shouldLoadMoreData = true
    private var lastDoc: QueryDocumentSnapshot?
    
    func fetchPosts() async throws -> [Post] {
        let likedPostIDs = try await fetchPostIDs()
        
        var result = [Post]()
        
        try await withThrowingTaskGroup(of: Post.self) { group in
            for likedPostId in likedPostIDs {
                group.addTask {
                    return try await PostService.fetchPost(likedPostId)
                }
            }
            
            for try await post in group {
                result.append(post)
            }
        }
        
        return result
    }
    
    private func fetchPostIDs() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid, shouldLoadMoreData else { return [] }
        
        let query = FirebaseConstants.UserLikesCollection(uid: uid).limit(to: fetchLimit)
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            // pagination
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
        } else {
            // first pull
            snapshot = try await query.getDocuments()
            lastDoc = snapshot.documents.last
        }
        
        let result = snapshot.documents.map { $0.documentID }
        shouldLoadMoreData = result.count == fetchLimit
        
        return result
    }
}
