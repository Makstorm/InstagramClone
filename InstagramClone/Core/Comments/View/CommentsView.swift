//
//  CommentsView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 22.04.2026.
//

import SwiftUI

struct CommentsView: View {
    @EnvironmentObject private var userManager: UserManager
    @State private var commnentText = ""
    @StateObject var viewModel: CommentsViewModel
    
    init(post: Post) {
        self._viewModel = StateObject(
            wrappedValue: CommentsViewModel(
                post: post,
                commentService: CommentService(postId: post.id),
                userService: UserService(),
            )
        )
    }
    
    var body: some View {
        VStack {
            Text("Comments")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.top, 24)
            
            Divider()
            
            ScrollView {
                switch viewModel.loadingState {
                case .empty:
                    EmptyStateView(
                        "No comments yet",
                        systemImage: "bubble.circle",
                        description: "Be the first to comment and add yours below!"
                    )
                    .frame(height: 400)
                case .error:
                    Text("An error occurred")
                case .loading:
                    ProgressView()
                case .complete:
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.comments) { commnet in
                            CommentsCell(commnet: commnet)
                        }
                    }
                }
            }
            
            Divider()
            
            HStack(spacing: 12) {
                CircularProfileImageView(user: userManager.currentUser, size: .xSmall)
                
                ZStack(alignment: .trailing) {
                    TextField("Add a commnet...", text: $commnentText)
                        .font(.footnote)
                        .padding(12)
                        .padding(.trailing, 40)
                        .overlay {
                            Capsule()
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        }
                    
                    Button {
                        uploadComment()
                    } label: {
                        Text("Post")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(.blue))
                    }
                    .padding(.horizontal)
                }
            }
            .padding(12)
        }
        .task {
            await viewModel.fetchComments()
        }
    }
}

private extension CommentsView {
    func uploadComment() {
        Task {
            guard let currentUser = userManager.currentUser else { return }
            
            let tempCommentText = commnentText
            commnentText = ""
            
            await viewModel.uploadComment(
                    commentText: tempCommentText,
                    currentUser: currentUser
            )
            
            commnentText = ""
        }
    }
}

#Preview {
    CommentsView(post: MockData.posts[0])
}
