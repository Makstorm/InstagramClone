//
//  UserService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 20.04.2026.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation

protocol UserServiceProtocol {
    func fetchCurrentUser() async throws -> User?
    func fetchUser(withUid uId: String) async throws -> User
    func updateUserAccountPrivacy(_ isPrivate: Bool) async throws
}

class UserService: UserServiceProtocol {
    func fetchCurrentUser() async throws -> User? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        return try await FirebaseConstants
            .UserCollection
            .document(uid)
            .getDocument(as: User.self)
    }
    
    func fetchUser(withUid uId: String) async throws -> User {
        let snapshot = try await FirebaseConstants.UserCollection.document(uId)
            .getDocument()
        return try snapshot.data(as: User.self)
    }
    
    func updateUserAccountPrivacy(_ isPrivate: Bool) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try await FirebaseConstants.UserCollection.document(currentUid).updateData(["isPrivate": isPrivate])
    }

    
}

// MARK: - User Stats

extension UserService {
    static func fetchUserStats(uid: String) async throws -> UserStats {
        async let followingCount = FirebaseConstants.FollowingCollection
            .document(uid).collection("user-following").getDocuments().count

        async let followersCount = FirebaseConstants.FollowersCollection
            .document(uid).collection("user-followers").getDocuments().count

        async let postsCount = FirebaseConstants.PostsCollection.whereField(
            "ownerUid",
            isEqualTo: uid
        ).getDocuments().count

        return try await .init(
            followersCount: followersCount,
            followingCount: followingCount,
            postsCount: postsCount
        )
    }
}
