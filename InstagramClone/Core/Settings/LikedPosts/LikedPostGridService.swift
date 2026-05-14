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
//    outdated due to cache utilization
//    private var lastDoc: QueryDocumentSnapshot?
    private lazy var postIDs = LikesCache.shared.getData()
    private var indexOfLastFetchedPost = 0
    
    func fetchPosts() async throws -> [Post] {
        let likedPostIDs = fetchPostIDsFromCache()
        
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
    
    private func fetchPostIDsFromCache() -> [String] {
        guard shouldLoadMoreData else { return [] }
        
        let startIndex = indexOfLastFetchedPost
        let endIndex = min(startIndex + fetchLimit, postIDs.count)
        
        indexOfLastFetchedPost = endIndex
        shouldLoadMoreData = endIndex < postIDs.count
        
        return Array(postIDs[startIndex ..< endIndex])
    }

    // previous implementation before utilizing cache
//    private func fetchPostIDs() async throws -> [String] {
//        guard let uid = Auth.auth().currentUser?.uid, shouldLoadMoreData else { return [] }
//        
//        let query = FirebaseConstants.UserLikesCollection(uid: uid).limit(to: fetchLimit)
//        let snapshot: QuerySnapshot
//        
//        if let lastDoc {
//            // pagination
//            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
//        } else {
//            // first pull
//            snapshot = try await query.getDocuments()
//            lastDoc = snapshot.documents.last
//        }
//        
//        let result = snapshot.documents.map { $0.documentID }
//        shouldLoadMoreData = result.count == fetchLimit
//        
//        return result
//    }
}
