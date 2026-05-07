//
//  FeedViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 20.04.2026.
//

import Combine
import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var loadingState: ContentLoadingState = .loading
    
    private let feedService: FeedServiceProtocol
    private let userService: UserServiceProtocol
    
    init(feedService: FeedServiceProtocol, userService: UserServiceProtocol) {
        self.feedService = feedService
        self.userService = userService
    }
    
    func fetchPosts() async {
        do {
            let result = try await feedService.fetchFeedPosts()
            posts.append(contentsOf: result)
            
            try await fetchPostUserData()
            self.loadingState = posts.isEmpty ? .empty : .complete
        } catch {
            loadingState = .error
            print("DEBUG: Failed to fetch posts with error: \(error.localizedDescription)")
        }
    }
    
    func refreshPosts() async {
        do {
            self.loadingState = .loading
            self.posts.removeAll()
            self.posts = try await feedService.refreshPosts()
            try await fetchPostUserData()
            self.loadingState = posts.isEmpty ? .empty : .complete
        } catch {
            loadingState = .error
            print("DEBUG: Failed to refresh posts with error \(error.localizedDescription)")
        }
    }
    
    private func fetchPostUserData() async throws {
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

extension FeedViewModel {
    func like(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        do {
            self.posts[index].didLike = true
            self.posts[index].likes += 1
            
            try await feedService.like(post)
        } catch {
            posts[index].didLike = false
            posts[index].likes -= 1
        }
    }
    
    func unlike(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        do {
            self.posts[index].didLike = false
            self.posts[index].likes -= 1
            
            try await feedService.unlike(post)
        } catch {
            posts[index].didLike = true
            posts[index].likes += 1
        }
    }
    
    func checkIfUserLikedPost(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        do {
            self.posts[index].didLike = try await feedService.checkIfUserLikedPost(post)
        } catch {
            print("DEBUG: Failed to check post like value with error: \(error.localizedDescription)")
        }
    }
    
    func save(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        do {
            self.posts[index].didSave = true
            try await feedService.save(post)
        } catch {
            self.posts[index].didSave = false
            print("DEBUB: Failed to save a post with error: \(error.localizedDescription)")
        }
    }
    
    func unsave(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }

        do {
            self.posts[index].didSave = false
            try await feedService.unsave(post)
        } catch {
            self.posts[index].didSave = true
            print("DEBUG: Failed to unsave a post with error: \(error.localizedDescription)")
        }
    }
    
    func checkIfUserSavedPost(_ post: Post) async {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        do {
            self.posts[index].didSave = try await feedService.checkIfUserSavedPost(post)
        } catch {
            print("DEBUG: Failed to check post save value with error: \(error.localizedDescription)")
        }
    }
}
