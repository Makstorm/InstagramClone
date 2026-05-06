//
//  CommentService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 22.04.2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol CommentServiceProtocol {
    func uploadComment(commentText: String, postOwnerUid: String) async throws -> Comment
    func fetchComments() async throws -> [Comment]
    
    var postId: String { get }
}

struct CommentService: CommentServiceProtocol {
    
    let postId: String
    
    func uploadComment(commentText: String, postOwnerUid: String) async throws -> Comment {
        guard let currentuid = Auth.auth().currentUser?.uid else { throw UserError.invalidUserId }
        let ref = FirebaseConstants
            .PostsCollection
            .document(postId)
            .collection("post-comments")
            .document()

        let comment = Comment(
            id: ref.documentID,
            postOwnerUid: postOwnerUid,
            commnetText: commentText,
            postId: postId,
            timestamp: Date(),
            commentOwnerUid: currentuid
        )
        let commentData = try Firestore.Encoder().encode(comment)
        
        try await FirebaseConstants.PostsCollection.document(postId).collection("post-comments").addDocument(data: commentData)
        
        return comment
    }
    
    func fetchComments() async throws -> [Comment] {
        let snapshot = try await FirebaseConstants.PostsCollection.document(postId).collection("post-comments").order(by: "timestamp", descending: true).getDocuments()
        
        return snapshot.documents.compactMap {
            try? $0.data(as: Comment.self)
        }
    }
}
