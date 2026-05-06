//
//  CommentsViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 22.04.2026.
//

import Combine
import FirebaseAuth
import Foundation

class CommentsViewModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var loadingState: ContentLoadingState = .loading
    private let post: Post
    private let userService: UserServiceProtocol
    private let commentService: CommentServiceProtocol
    
    init(post: Post, commentService: CommentServiceProtocol ,userService: UserServiceProtocol) {
        self.post = post
        self.commentService = commentService
        self.userService = userService
        
        
    }

    func uploadComment(commentText: String, currentUser: User) async {
        do {
            var comment = try await commentService.uploadComment(commentText: commentText, postOwnerUid: post.ownerUid)
            comment.user = currentUser
            comments.insert(comment, at: 0)
            
            if loadingState == .empty {
                loadingState = .complete
            }
            
            Task {
                NotificationManager.shared.uploadCommentNotification(toUid: post.ownerUid, post: post)
            }
        } catch {
            loadingState = .error
        }
    }
    
    @MainActor
    func fetchComments() async {
        do {
            let tempComments = try await commentService.fetchComments()
            try await fetchUserDataForComments(tempComments)
            loadingState = comments.isEmpty ? .empty : .complete
        } catch {
            loadingState = .error
            print("DEBUG: Failed to fetch comment with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func fetchUserDataForComments(_ comments: [Comment]) async throws {
        var result = comments
        try await withThrowingTaskGroup(of: (Int, User).self) { [weak self] group in
            guard let self else { return }
            
            for (index, comment) in comments.enumerated() {
                group.addTask {
                    let user = try await self.userService.fetchUser(withUid: comment.commentOwnerUid)
                    return (index, user)
                }
            }
            
            for try await (index, user) in group {
                result[index].user = user
            }
        }
        
        self.comments = result
    }
}
