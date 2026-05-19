//
//  UploadPostView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 18.04.2026.
//

import SwiftUI
import PhotosUI

struct UploadPostView: View {
    @State private var caption = ""
    @State private var imagePickerPresented = false
    @StateObject var viewModel = UploadPhotoViewModel(service: UploadPostService())
    
    @EnvironmentObject private var router: TabRouter
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // post image and caption
                HStack(spacing: 8) {
                    if let image = viewModel.postImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .clipped()
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.secondarySystemFill))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "photo.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                        .onTapGesture { imagePickerPresented.toggle() }
                    }
                    
                    TextField("Enter your caption...", text: $caption, axis: .vertical)
                }
                
                if viewModel.postImage == nil {
                    Text("You must select an image to upload a post")
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New post")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { imagePickerPresented.toggle() }
            .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImage)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { clearPostDataAndReturnToFeed() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button { uploadPost() } label: {
                        ZStack {
                            if let loadingState = viewModel.loadingState, loadingState == .loading {
                                ProgressView()
                            } else {
                                Text("Upload")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .disabled(viewModel.loadingState == .loading || viewModel.postImage == nil)
                    .opacity(viewModel.postImage == nil ? 0.5 : 1.0)
                }
            }
        }
    }
}

private extension UploadPostView {
    func clearPostDataAndReturnToFeed() {
        caption = ""
        viewModel.selectedImage = nil
        viewModel.postImage = nil
        router.goTo(0)
    }
    
    func uploadPost() {
        Task {
            await viewModel.uploadPost(caption: caption)
            clearPostDataAndReturnToFeed()
        }
    }
}

#Preview {
    UploadPostView()
}
