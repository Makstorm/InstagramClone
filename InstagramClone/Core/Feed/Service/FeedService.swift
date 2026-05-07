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
    func like(_ post: Post) async throws
    func unlike(_ post: Post) async throws
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool
    func save(_ post: Post) async throws
    func unsave(_ post: Post) async throws
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool
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
        return try await fetchFeedPosts()
    }
    
    func like(_ post: Post) async throws {
        try await PostService.likePost(post)
        NotificationManager.shared.uploadLikeNotification(toUid: post.ownerUid, post: post)
    }

    func unlike(_ post: Post) async throws {
        try await PostService.unlikePost(post)
        await NotificationManager.shared.deleteLikeNotification(
                notificationOwnerUid: post.ownerUid,
                post: post
            )
    }
    
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        return try await PostService.checkIfUserLikedPost(post)
    }
    
    func save(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await FirebaseConstants.UserSavedPostsCollection(uid: uid).document(post.id).setData([:])
    }
    
    func unsave(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await FirebaseConstants.UserSavedPostsCollection(uid: uid).document(post.id).delete()
    }
    
    func checkIfUserSavedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        return try await FirebaseConstants.UserSavedPostsCollection(uid: uid).document(post.id).getDocument().exists
    }
}

private extension FeedService {
    func fetchPostIDs() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid, shouldLoadMoreData else { return [] }
        
        let query = FirebaseConstants.UserFeedCollection(uid: uid).limit(to: fetchLimit)
       
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            // fetch next batch of posts
            let next = query.start(afterDocument: lastDoc)
            snapshot = try await next.getDocuments()
            shouldLoadMoreData = snapshot.documents.last != nil
            if let lastId = snapshot.documents.last {
                self.lastDoc = lastId
            }
        } else {
            // first time fetching
            snapshot = try await query.getDocuments()
            shouldLoadMoreData = snapshot.documents.count == fetchLimit
            lastDoc = snapshot.documents.last
        }
        
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
