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

    static func fetchAllUsers() async throws -> [User] {
        let snapshot = try await FirebaseConstants.UserCollection.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
    }

    static func fetchUsers(forConfig config: UserListConfig) async throws
        -> [User]
    {
        switch config {
        case .followers(let uid): return try await fetchFollowers(uid: uid)
        case .following(let uid): return try await fetchFollowing(uid: uid)
        case .likes(let postId): return try await fetchPostLikesUser(uid: postId)
        case .explore: return try await fetchAllUsers()
        }
    }

    private static func fetchFollowers(uid: String) async throws -> [User] {
        let snapshot = try await FirebaseConstants.FollowersCollection.document(
            uid
        ).collection("user-followers").getDocuments()
        return try await fetchUsers(snapshot)
    }

    private static func fetchFollowing(uid: String) async throws -> [User] {
        let snapshot = try await FirebaseConstants.FollowingCollection.document(
            uid
        ).collection("user-following").getDocuments()
        return try await fetchUsers(snapshot)
    }

    private static func fetchPostLikesUser(uid: String) async throws -> [User] {
        return []
    }

    private static func fetchUsers(_ snapshot: QuerySnapshot) async throws
        -> [User]
    {
//        var users = [User]()
//        for doc in snapshot.documents {
//            let uid = doc.documentID
//            users.append(try await fetchUser(withUid: uid))
//        }
//        return users
        return []
    }
}

// MARK: - Following

extension UserService {
    static func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        async let _ = try await FirebaseConstants.FollowingCollection.document(
            currentUid
        ).collection("user-following").document(uid).setData([:])

        async let _ = try await FirebaseConstants.FollowersCollection.document(
            uid
        ).collection("user-followers").document(currentUid).setData([:])
    }

    static func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        async let _ = try await FirebaseConstants.FollowingCollection.document(
            currentUid
        ).collection("user-following").document(uid).delete()

        async let _ = try await FirebaseConstants.FollowersCollection.document(
            uid
        ).collection("user-followers").document(currentUid).delete()
    }

    static func checkIfUserIsFollowed(uid: String) async throws -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return false
        }

        let snapshot = try await FirebaseConstants.FollowingCollection.document(
            currentUid
        ).collection("user-following").document(uid).getDocument()

        print("DEBUG: Got triggered checkIfUserIsFollowed via ProfileHeaderView with result: \(snapshot.exists)")
        return snapshot.exists
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
