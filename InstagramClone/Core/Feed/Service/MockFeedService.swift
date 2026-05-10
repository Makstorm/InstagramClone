//
//  MockFeedService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 09.05.2026.
//

import Foundation

class MockFeedService: FeedServiceProtocol {
    func fetchFeedPosts() async throws -> [Post] {
        var result = [Post]()
        let currentUserFollows = [MockData.users[0].id, MockData.users[1].id]
        
        for post in MockData.posts {
            if currentUserFollows.contains(post.ownerUid) {
                result.append(post)
            }
        }
        
        return result
    }
    
    func refreshPosts() async throws -> [Post] {
       return try await fetchFeedPosts()
    }
}
