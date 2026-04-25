//
//  FeedCellViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 21.04.2026.
//

import Combine
import Foundation

@MainActor
class FeedCellViewModel: ObservableObject {
    @Published var post: Post

    init(post: Post) {
        self.post = post
        
        Task {
            try await checkIfUserLikedPost()
        }
    }

    func like() async throws {
        do {
            let postCopy = post
            post.didLike = true
            post.likes += 1
            try await PostService.likePost(postCopy)
            NotificationManager.shared.uploadLikeNotification(toUid: post.ownerUid, post: post)
        } catch {
            post.didLike = false
            post.likes -= 1
        }
    }

    func unlike() async throws {
        do {
            let postCopy = post
            post.didLike = false
            post.likes -= 1
            try await PostService.likePost(postCopy)
           
            await NotificationManager.shared.deleteLikeNotification(notificationOwnerUid: post.ownerUid, post: post)
        } catch {
            post.didLike = true
            post.likes += 1
        }
    }
    
    func checkIfUserLikedPost() async throws {
        self.post.didLike = try await PostService.checkIfUserLikedPost(post)
    }
}
