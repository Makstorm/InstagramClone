//
//  PostGrigViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 20.04.2026.
//

import Combine
import Foundation

@MainActor
class PostGridViewModel: FeedViewModelProtocol {
    @Published var posts = [Post]()
    @Published var loadingState: ContentLoadingState = .loading
    
    private let service: PostGridServiceProtocol
    private(set) var likePostService: LikePostServiceProtocol
    private(set) var savePostService: SavePostServiceProtocol
    private(set) var userService: UserServiceProtocol
    
    init(
        service: PostGridServiceProtocol,
        likePostService: LikePostServiceProtocol,
        savePostService: SavePostServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.service = service
        self.likePostService = likePostService
        self.savePostService = savePostService
        self.userService = userService

        Task { await fetchPosts() }
    }
    
    func fetchPosts() async {
        do {
            let result = try await service.fetchPosts()
            posts.append(contentsOf: result)
            try await fetchPostUserData()
            loadingState = posts.isEmpty ? .empty : .complete
        } catch {
            print("DEBAG: Failed to fetch posts with error: \(error.localizedDescription)")
        }
    }
    
}
