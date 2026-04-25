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

    private static let postsCollection = FirebaseConstants.PostsCollection

    // used in feed page to load posts
    static func fetchFeedPosts() async throws -> [Post] {
        let snapShot = try await postsCollection.getDocuments()
        //        self.posts = try snapShot.documents.compactMap({ document in
        //            let post = try document.data(as: Post.self)
        //            return post
        //        })
        //
        //        for i in 0..<posts.count {
        //            let post = posts[i]
        //
        //            let ownerUid = post.ownerUid
        //            let postUser = try await UserService.fetchUser(withUid: ownerUid)
        //            posts[i].user = postUser
        //        }

        var loadedPosts = try snapShot.documents.compactMap { document in
            try document.data(as: Post.self)
        }

        try await withThrowingTaskGroup(of: (Int, User).self) { group in
            for (index, post) in loadedPosts.enumerated() {
                group.addTask {
                    let user = try await UserService.fetchUser(
                        withUid: post.ownerUid
                    )
                    return (index, user)
                }
            }

            for try await (index, user) in group {
                loadedPosts[index].user = user
            }
        }

        return loadedPosts
    }

    static func fetchUserPosts(uid: String) async throws -> [Post] {
        let snapshot = try await postsCollection.whereField(
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

extension PostService {
    static func likePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _  = try await postsCollection.document(post.id).collection("post-likes").document(uid).setData([:])
        async let _ = try await postsCollection.document(post.id).updateData(["likes": post.likes + 1])
        async let _ = try FirebaseConstants.UserCollection.document(uid).collection("user-likes").document(post.id).setData([:])
    }
    
    static func unlikePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _  = try await postsCollection.document(post.id).collection("post-likes").document(uid).delete()
        async let _ = try await postsCollection.document(post.id).updateData(["likes": post.likes - 1])
        async let _ = try FirebaseConstants.UserCollection.document(uid).collection("user-likes").document(post.id).delete()
    }
    
    static func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        let snapshot = try await FirebaseConstants.UserCollection.document(uid).collection("user-likes").document(post.id).getDocument()
        return snapshot.exists
    }
}
