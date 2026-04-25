//
//  FeedView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.posts) { post in
                        FeedCell(post: post)
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.instagramLogoBlack)
                        .resizable()
                        .frame(width: 100, height: 32)
                }
                .sharedBackgroundVisibility(.hidden)

                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "paperplane")
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .onAppear {
                Task {
                    try await viewModel.fetchPosts()
                }
            }
        }
    }
}

#Preview {
    FeedView()
}
