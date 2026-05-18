//
//  FollowService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 14.05.2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FollowServiceProtocol {
    func follow(uid: String) async throws
    func fetchUserRelatioState(uid: String) async throws -> UserRelationState
    func removeFollowRequest(to uid: String) async throws
    func sendFollowRequest(to uid: String) async throws
    func unfollow(uid: String) async throws
}

class FollowService: FollowServiceProtocol {
    private var pendingFollowRequest: FollowRequest?

    func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        let batch = Firestore.firestore().batch()

        let followingRef = FirebaseConstants
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)

        let followerRef = FirebaseConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
        
        batch.setData([:], forDocument: followingRef)
        batch.setData([:], forDocument: followerRef)
        
        try await batch.commit()
    }

    func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()

        let followingRef = FirebaseConstants
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)

        let followerRef = FirebaseConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
        
        batch.deleteDocument(followingRef)
        batch.deleteDocument(followerRef)
        
        try await batch.commit()
    }

    func fetchUserRelatioState(uid: String) async throws -> UserRelationState {
        guard let currentUid = Auth.auth().currentUser?.uid else { return .unknown }

        let isFollowed = try await FirebaseConstants
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .getDocument()

        if isFollowed.exists { return .followed }

        let pendingRequests = try await FirebaseConstants
            .FollowRequestsCollection(uid: uid)
            .whereField("fromUserId",isEqualTo: currentUid)
            .limit(to: 1)
            .getDocuments(as: FollowRequest.self)
        
        if !pendingRequests.isEmpty {
            self.pendingFollowRequest = pendingRequests.first
            return .requestedToFollow
        }

        return .notFollowed
    }
    
    func sendFollowRequest(to uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let requestRef = FirebaseConstants.FollowRequestsCollection(uid: uid).document()
        let followRequest = FollowRequest(
            id: requestRef.documentID,
            toUserId: uid,
            fromUserId: currentUid,
            timestamp: Date()
        )
        
        let data = try Firestore.Encoder().encode(followRequest)
        
        try await requestRef.setData(data)
    }
    
    func removeFollowRequest(to uid: String) async throws {
        guard let pendingFollowRequest else { return }
        
        try await FirebaseConstants
            .FollowRequestsCollection(uid: uid)
            .document(pendingFollowRequest.id)
            .delete()
    }
}
