//
//  FeedViewModelProtocol.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 13.05.2026.
//

import Foundation
import Combine

@MainActor
protocol FeedViewModelProtocol: ObservableObject {
    var posts: [Post] { get set }
    var likePostService: LikePostServiceProtocol { get }
    var savePostService: SavePostServiceProtocol { get }
    var userService: UserServiceProtocol { get }
    var notificationManager: NotificationManager { get }
    
    func like(_ post: Post) async
    func unlike(_ post: Post) async
    func didLike(_ post: Post) async
    
    func save(_ post: Post) async
    func unsave(_ post: Post) async 
    func didSave(_ post: Post) async 
}

extension FeedViewModelProtocol {
    func like(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        do {
            self.posts[index].didLike = true
            self.posts[index].likes += 1
            
            try await likePostService.likePost(post)
            try await notificationManager.uploadLikeNotification(toUid: post.ownerUid, post: post)
        } catch {
            posts[index].didLike = false
            posts[index].likes -= 1
        }
    }
    
    func unlike(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        guard post.likes > 0 else { return }
        
        do {
            self.posts[index].didLike = false
            self.posts[index].likes -= 1
            
            try await likePostService.unlikePost(post)
            await notificationManager.deleteLikeNotification(notificationOwnerUid: post.ownerUid, post: post)
        } catch {
            posts[index].didLike = true
            posts[index].likes += 1
        }
    }
    
    func didLike(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        do {
            self.posts[index].didLike = try await likePostService.checkIfUserLikedPost(post)
        } catch {
            print("DEBUG: Failed to check post like value with error: \(error.localizedDescription)")
        }
    }
    
    func save(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        do {
            self.posts[index].didSave = true
            try await savePostService.save(post)
        } catch {
            self.posts[index].didSave = false
            print("DEBUB: Failed to save a post with error: \(error.localizedDescription)")
        }
    }
    
    func unsave(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }

        do {
            self.posts[index].didSave = false
            try await savePostService.unsave(post)
        } catch {
            self.posts[index].didSave = true
            print("DEBUG: Failed to unsave a post with error: \(error.localizedDescription)")
        }
    }
    
    func didSave(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        do {
            self.posts[index].didSave = try await savePostService.checkIfUserSavedPost(post)
        } catch {
            print("DEBUG: Failed to check post save value with error: \(error.localizedDescription)")
        }
    }
}

extension FeedViewModelProtocol {
    func fetchPostUserData() async throws {
        var result = posts
        
        try await withThrowingTaskGroup(of: (Int, User).self) { [weak self] group in
            guard let self else { return }
            
            for (index, post) in posts.enumerated() {
                group.addTask {
                    let user = try await self.userService.fetchUser(
                        withUid: post.ownerUid
                    )
                    return (index, user)
                }
            }

            for try await (index, user) in group {
                result[index].user = user
            }
        }
        
        self.posts = result
    }
}
