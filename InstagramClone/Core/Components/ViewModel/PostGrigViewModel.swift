//
//  PostGrigViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 20.04.2026.
//

import Combine
import Foundation

class PostGrigViewModel: ObservableObject {
    private let user: User
    @Published var posts = [Post]()

    init(user: User) {
        self.user = user

        Task { try await fetchUserPosts() }
    }

    @MainActor
    func fetchUserPosts() async throws {
        self.posts = try await PostService.fetchUserPosts(uid: user.id)
        for i in 0..<posts.count {
            posts[i].user = self.user
        }
    }
}
