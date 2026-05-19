//
//  UploadPostService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 19.05.2026.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

protocol UploadPostServiceProtocol {
    func uploadPost(caption: String, image: UIImage) async throws
}

struct UploadPostService: UploadPostServiceProtocol {
    func uploadPost(caption: String, image: UIImage) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let postRef = FirebaseConstants.PostsCollection.document()
        guard let imageUrl = try await ImageUploader.uploadImage(image: image) else { return }
        
        let post = Post(
            id: postRef.documentID,
            ownerUid: uid,
            caption: caption,
            likes: 0,
            imageUrl: imageUrl,
            timestamb: Date()
        )
        
        let encodedPost = try Firestore.Encoder().encode(post)
        try await postRef.setData(encodedPost)
    }
}
