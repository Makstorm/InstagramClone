//
//  FeedViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 20.04.2026.
//

import Combine
import Foundation

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()

    init() {}

    @MainActor
    func fetchPosts() async throws {
        self.posts = try await PostService.fetchFeedPosts()
    }
}
