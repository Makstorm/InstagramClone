//
//  PostGridFeedView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 12.05.2026.
//

import SwiftUI
import Combine

struct PostGridFeedView: View {
    @Environment(\.dismiss) private var dissmiss
    @State private var scrollPosition: String?
    @ObservedObject var viewModel: PostGridViewModel
    
    init(selectedPost: Post, viewModel: PostGridViewModel) {
        _scrollPosition = State(initialValue: selectedPost.id)
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.posts) { post in
                        FeedCell(post: post, viewModel: viewModel)
                            .id(post.id)
                    }
                }
                .scrollTargetLayout()
            }
            .navigationDestination(for: FeedRouter.self)  { route in
                if case .profile(let user) = route  {
                    ProfileView(user: user)
                }
            }
            .scrollPosition(id: $scrollPosition, anchor: .top)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dissmiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color(.primaryText))
                    }

                }
            }
        }
    }
}

#Preview {
    PostGridFeedView(
        selectedPost: MockData.posts[0],
        viewModel: PostGridViewModel(
            service: SavedPostGridService(),
            likePostService: LikePostService(),
            savePostService: SavePostService(),
            userService: UserService()
        )
    )
}
