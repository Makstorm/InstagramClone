//
//  CommentsViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 22.04.2026.
//

import Combine
import Firebase
import FirebaseAuth
import Foundation

class CommentsViewModel: ObservableObject {
    @Published var comments = [Comment]()

    private let post: Post
    private let service: CommentService

    init(post: Post) {
        self.post = post
        self.service = CommentService(postId: post.id)
        
        Task {
            try await fetchComments()
        }
    }

    func uploadComment(commentText: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let comment = Comment(
            postOwnerUid: post.ownerUid,
            commnetText: commentText,
            postId: post.id,
            timestamp: Timestamp(),
            commentOwnerUid: uid
        )
        
        try await service.uploadComment(comment)
        try await fetchComments()
        
        NotificationManager.shared.uploadCommentNotification(toUid: post.ownerUid, post: post)
    }
    
    @MainActor
    func fetchComments() async throws {
        self.comments = try await service.fetchComments()
        try await fetchUserDataForComments()
    }
    
    @MainActor
    private func fetchUserDataForComments() async throws {
        for i in 0 ..< comments.count {
            let comment = comments[i]
            let user = try await UserService.fetchUser(withUid: comment.commentOwnerUid)
            comments[i].user = user
        }
    }
}
