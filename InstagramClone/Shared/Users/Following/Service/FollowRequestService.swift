//
//  FollowRequestService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.05.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol FollowRequestServiceProtocol {
    func fetchFollowRequests() async throws -> [FollowRequest]
    func accept(_ request: FollowRequest) async throws
    func reject(_ request: FollowRequest) async throws
}

struct FollowRequestService: FollowRequestServiceProtocol {
    func fetchFollowRequests() async throws -> [FollowRequest] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        
        return try await FirebaseConstants
            .FollowRequestsCollection(uid: currentUid)
            .getDocuments(as: FollowRequest.self)
    }
    
    func accept(_ request: FollowRequest) async throws {
        try await triggerFollow(from: request.fromUserId)
        try await deleteFollowRequest(request)
    }
    
    func reject(_ request: FollowRequest) async throws {
        try await deleteFollowRequest(request)
    }
    
    private func deleteFollowRequest(_ request: FollowRequest) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try await FirebaseConstants
            .FollowRequestsCollection(uid: currentUid)
            .document(request.id)
            .delete()
    }
    
    private func triggerFollow(from uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let batch = Firestore.firestore().batch()
        
        let followingRef = FirebaseConstants
            .FollowingCollection
            .document(uid)
            .collection("user-following")
            .document()
        
        let followeRef = FirebaseConstants
            .FollowersCollection
            .document(currentUid)
            .collection("user-followers")
            .document(uid)
        
        batch.setData([:], forDocument: followingRef)
        batch.setData([:], forDocument: followeRef)
        
        try await batch.commit()
    }
}
