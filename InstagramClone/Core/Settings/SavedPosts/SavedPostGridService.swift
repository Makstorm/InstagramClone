//
//  SavedPostGridService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 11.05.2026.
//
import FirebaseAuth
import FirebaseFirestore

class SavedPostGridService: PostGridServiceProtocol {
    private let fetchLimit = 21
    private var shouldLoadMoreData = true
    private var lastDoc: QueryDocumentSnapshot?
    
    func fetchPosts() async throws -> [Post] {
        let savedPostIDs = try await fetchPostIDs()
        
        if savedPostIDs.isEmpty { return [] }
        
        var result = [Post]()
        
        try await withThrowingTaskGroup(of: Post.self) { group in
            for savedPostId in savedPostIDs {
                group.addTask {
                    return try await PostService.fetchPost(savedPostId)
                }
            }
            
            for try await post in group {
                result.append(post)
            }
        }
        
        return result.sorted { $0.timestamb > $1.timestamb }
    }
    
    private func fetchPostIDs() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid, shouldLoadMoreData else { return [] }
        
        let query = FirebaseConstants.UserSavedPostsCollection(uid: uid).limit(to: fetchLimit)
        let snapshot: QuerySnapshot
        
        if let lastDoc {
            // pagination
            snapshot = try await query.start(afterDocument: lastDoc).getDocuments()
        } else {
            // first pull
            snapshot = try await query.getDocuments()
            lastDoc = snapshot.documents.last
        }
        
        let result = snapshot.documents.map { $0.documentID }
        shouldLoadMoreData = result.count == fetchLimit
        
        return result
    }
}
