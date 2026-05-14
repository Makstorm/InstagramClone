//
//  PostGridView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import SwiftUI
import Kingfisher

enum PostGridViewConfiguration {
    case profile
    case likedPosts
    case savedPosts
}

struct PostGridView: View {
    @ObservedObject var viewModel: PostGridViewModel
    @State private var selectedPost: Post?
    
    private let configuration: PostGridViewConfiguration
    
    init(viewModel: PostGridViewModel, configuration: PostGridViewConfiguration) {
        self.viewModel = viewModel
        self.configuration = configuration
    }
        
    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .empty:
                IGContentUnavailableView(
                    emptyStateTitle,
                    systemImage: emptyStateImageName,
                    description: emptyStateDescription
                )
                .frame(height: 400)
            case .error:
                Text("Failed to load posts...")
            case .loading:
                ProgressView()
                    .frame(height: 400)
            case .complete:
                LazyVGrid(columns: gridItems, spacing: 1) {
                    ForEach(viewModel.posts) { post in
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageDimention, height: imageDimention)
                            .clipped()
                            .contentShape(.rect)
                            .onAppear { loadMorePosts(post) }
                            .onTapGesture { selectedPost = post }
                    }
                }
                .fullScreenCover(item: $selectedPost) { post in
                    PostGridFeedView(selectedPost: post,viewModel: viewModel)
                }
            }
        }
    }
}

private extension PostGridView {
    func loadMorePosts(_ lastPost: Post) {
        Task {
            guard lastPost == viewModel.posts.last else { return }
            await viewModel.fetchPosts()
        }
    }
}

private extension PostGridView {
    var gridItems: [GridItem] {
        return [
            .init(.flexible(), spacing: 1),
            .init(.flexible(), spacing: 1),
            .init(.flexible(), spacing: 1),
        ]
    }
    
    var imageDimention: CGFloat {
        return (UIScreen.main.bounds.width / 3) - 1
    }

    var emptyStateTitle: String {
        switch configuration {
        case .profile: return "No Posts Yet."
        case .likedPosts: return "No Liked posts."
        case .savedPosts: return "No Saved posts."
        }
    }
    
    var emptyStateImageName: String {
        switch configuration {
        case .profile: return "camera.circle"
        case .likedPosts: return "heart.circle"
        case .savedPosts: return "bookmark.circle"
        }
    }
    
    var emptyStateDescription: String? {
        switch configuration {
        case .profile: return nil
        case .likedPosts: return "Liked posts will appear here."
        case .savedPosts: return "Saved posts will appear here."
        }
    }
}

#Preview {
    PostGridView(
        viewModel: PostGridViewModel(
            service: SavedPostGridService(),
            likePostService: LikePostService(),
            savePostService: SavePostService(),
            userService: UserService()
        ),
        configuration: .profile
    )
}
