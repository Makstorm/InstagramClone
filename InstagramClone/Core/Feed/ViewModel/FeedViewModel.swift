//
//  FeedViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 20.04.2026.
//

import Combine
import Foundation

@MainActor
class FeedViewModel: FeedViewModelProtocol {
    @Published var posts = [Post]()
    @Published var loadingState: ContentLoadingState = .loading
    
    private let feedService: FeedServiceProtocol
    private(set) var userService: UserServiceProtocol
    private(set) var likePostService: LikePostServiceProtocol
    private(set) var savePostService: SavePostServiceProtocol
    
    init(
        feedService: FeedServiceProtocol,
        userService: UserServiceProtocol,
        likePostService: LikePostServiceProtocol,
        savePostService: SavePostServiceProtocol
    ) {
        self.feedService = feedService
        self.userService = userService
        self.likePostService = likePostService
        self.savePostService = savePostService
        
        Task {
            await fetchPosts()
        }
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

