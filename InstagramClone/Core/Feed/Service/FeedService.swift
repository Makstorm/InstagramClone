//
//  FeedService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 06.05.2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FeedServiceProtocol {
    func fetchFeedPosts() async throws -> [Post]
    func refreshPosts() async throws -> [Post]
}

class FeedService: FeedServiceProtocol {
    private var lastDoc: QueryDocumentSnapshot?
    private var shouldLoadMoreData = true
    private var fetchLimit = 3
    
    func fetchFeedPosts() async throws -> [Post] {
        let postIds = try await fetchPostIDs()
        return try await fetchPosts(with: postIds)
    }
   
    func refreshPosts() async throws -> [Post] {
        lastDoc = nil
        shouldLoadMoreData = true
        return try await fetchFeedPosts()
    }
}

private extension FeedService {
    func fetchPostIDs() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid, shouldLoadMoreData else { return [] }
        
        let query = FirebaseConstants.UserFeedCollection(uid: uid).limit(to: fetchLimit)
       
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
        } else {
            snapshot = try await query.getDocuments()
        }
        
        if let lastId = snapshot.documents.last { self.lastDoc = lastId }
        shouldLoadMoreData = snapshot.documents.count == fetchLimit
        
        return snapshot.documents.map { $0.documentID }
    }
    
    func fetchPosts(with postIds: [String]) async throws -> [Post] {
        var result = [Post]()
        
        try await withThrowingTaskGroup(of: Post.self) { group in
            for id in postIds {
                group.addTask { return try await PostService.fetchPost(id) }
            }
            
            for try await post in group {
                result.append(post)
            }
        }
        
        return result.sorted(by: {
            $0.timestamb > $1.timestamb
        })
    }
}
