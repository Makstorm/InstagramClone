//
//  NotificationPostFeedViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 19.05.2026.
//

import Foundation
import Combine

class NotificationPostFeedViewModel: FeedViewModelProtocol {
    @Published var posts: [Post] = []
    
    var likePostService: LikePostServiceProtocol
    var savePostService: SavePostServiceProtocol
    var userService: UserServiceProtocol
    var notificationManager: NotificationManager
    
    init(
        likePostService: LikePostServiceProtocol = LikePostService(),
        savePostService: SavePostServiceProtocol = SavePostService(),
        userService: UserServiceProtocol = UserService(),
        notificationManager: NotificationManager = NotificationManager(service: NotificationManagerService())
    ) {
        self.likePostService = likePostService
        self.savePostService = savePostService
        self.userService = userService
        self.notificationManager = notificationManager
    }
    
    func configurePostUserData() async {
        print("DEBUG: Getting post user data")
        
        do {
            try await fetchPostUserData()
            print("DEBUG: Post user is \(posts.first?.user?.username)")
        } catch {
            print("DEBUG: Failed to fetch post user data with error \(error.localizedDescription)")
        }
    }
}
