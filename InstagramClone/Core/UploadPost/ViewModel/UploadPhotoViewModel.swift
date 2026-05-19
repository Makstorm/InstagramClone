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
        didSet {
            Task { await loadImage(fromItem: selectedImage) }
        }
    }
    @Published var postImage: Image?
    @Published var loadingState: ContentLoadingState?

    private let service: UploadPostServiceProtocol
    
    init(service: UploadPostServiceProtocol) {
        self.service = service
    }

    
    private var uiImage: UIImage?
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let selectedItem = item else { return }
        guard let data = try? await selectedItem.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadPost(caption: String) async {
        guard let uiImage else { return }
        
        loadingState = .loading
        
        do {
            try await service.uploadPost(caption: caption, image: uiImage)
            loadingState = .complete
        } catch {
            loadingState = .error
            print("DEBUG: Failed to upload post with error: \(error.localizedDescription)")
        }
    }
    
}
