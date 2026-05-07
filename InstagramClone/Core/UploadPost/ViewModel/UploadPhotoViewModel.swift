//
//  UploadPhotoViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 18.04.2026.
//

import SwiftUI
import Combine
import PhotosUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

@MainActor
class UploadPhotoViewModel: ObservableObject {
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    
    @Published var profileImage: Image?
    
    private var uiImage: UIImage?
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let selectedItem = item else { return }
        guard let data = try? await selectedItem.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func uploadPost(caption: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let uiImage = uiImage else { return }
        
        let postRef = FirebaseConstants.PostsCollection.document()
        guard let imageUrl = try await ImageUploader.uploadImage(image: uiImage) else { return }
        
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
        try await updateUserFeedsAfterPost(postId: post.id)
    }
    
    private func updateUserFeedsAfterPost(postId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // fetch followers of post owner
        
        let followersSnapshot = try await FirebaseConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        
        for document in followersSnapshot.documents {
            try await FirebaseConstants.UserFeedCollection(uid: document.documentID).document(postId).setData([:])
        }
        
        try await FirebaseConstants.UserFeedCollection(uid: uid).document(postId).setData([:])
    }
}
