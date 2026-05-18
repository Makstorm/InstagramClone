//
//  UserListService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.05.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol UserListServiceProtocol {
    func fetchUsers(forConfig config: UserListConfiguration) async throws -> [User]
}

class UserListService: UserListServiceProtocol {
    private let fetchLimit = 20
    private var lastDoc: QueryDocumentSnapshot?
    private var shouldLoadMoredata = true
    
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func fetchUsers(forConfig config: UserListConfiguration) async throws
        -> [User]
    {
        switch config {
        case .followers(let uid): return try await fetchFollowers(uid: uid)
        case .following(let uid): return try await fetchFollowing(uid: uid)
        case .likes(let postId): return try await fetchPostLikesUser(postId: postId)
        case .explore: return try await fetchAllUsers()
        }
    }
}

private extension UserListService {
    func fetchFollowers(uid: String) async throws -> [User] {
        let query = FirebaseConstants.UserFollowerCollection(uid: uid).limit(to: fetchLimit)
        return try await fetchUsers(withQuery: query)
    }

    func fetchFollowing(uid: String) async throws -> [User] {
        let query = FirebaseConstants.UserFollowingCollection(uid: uid).limit(to: fetchLimit)
        return try await fetchUsers(withQuery: query)
    }

    func fetchPostLikesUser(postId: String) async throws -> [User] {
        let query = FirebaseConstants.PostLikesCollection(postId: postId).limit(to: fetchLimit)
        return try await fetchUsers(withQuery: query)
    }

    func fetchAllUsers() async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid, shouldLoadMoredata else { return [] }
        
        let query = FirebaseConstants.UserCollection.limit(to: fetchLimit)
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
        } else {
            snapshot = try await query.getDocuments()
        }
        return snapshot
            .documents
            .compactMap { try? $0.data(as: User.self) }
            .filter { $0.id != currentUid }
    }
    
    func fetchUsers(withQuery query: Query) async throws -> [User] {
        guard let snapshot = try await paginatedSnapshot(withQuery: query) else { return [] }
        var users = [User]()
        
        try await withThrowingTaskGroup(of: User.self) { [weak self] group in
            guard let self else { return }
            
            for doc in snapshot.documents {
                group.addTask {
                    return try await self.userService.fetchUser(withUid: doc.documentID)
                }
            }
            
            for try await user in group {
                users.append(user)
            }
        }
        return users
    }
    
    func paginatedSnapshot(withQuery query: Query) async throws -> QuerySnapshot? {
        guard shouldLoadMoredata else { return nil }
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
        } else {
            snapshot = try await query.getDocuments()
        }
        
        if let last = snapshot.documents.last { self.lastDoc = last }
        shouldLoadMoredata = snapshot.documents.count == fetchLimit
        
        return snapshot
    }
}
