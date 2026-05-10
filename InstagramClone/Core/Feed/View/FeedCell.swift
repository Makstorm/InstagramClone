//
//  FeedCell.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI
import Combine
import Kingfisher

struct FeedCell: View {
    @ObservedObject var viewModel: FeedViewModel
    @State private var showComments = false
    @State private var showPostOptionsMenu = false
    
    private let post: Post
    
    init(post: Post, viewModel: FeedViewModel) {
        self.post = post
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            //image + username
            HStack {
                if let user = post.user {
                    NavigationLink(value: FeedRouter.profile(user)) {
                        CircularProfileImageView(user: user, size: .xSmall)
                        
                        Text(user.username)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    }
                }
                
                Spacer()
                
                Button { showPostOptionsMenu.toggle() } label: {
                    Image(systemName: "ellipsis")
                }
                
            }
            .padding(.horizontal)
            
            // post image
            
            GeometryReader { proxy in
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: 400)
                    .clipped()
                    .contentShape(.rect)
            }
            .frame(height: 400)
            
            //action button
            HStack {
                Button { handeleLikeTaped() } label: {
                    Image(systemName: post.didLike ? "heart.fill" : "heart")
                        .imageScale(.large)
                        .foregroundStyle(post.didLike ? .red : .black)
                }
                
                Button {
                    showComments.toggle()
                } label: {
                    Image(systemName: "bubble.right")
                        .imageScale(.large)
                }
                
                Button {
                    print("Share")
                } label: {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                }
                
                Spacer()
                
                Button { handleSaveTapped() } label: {
                    Image(systemName: post.didSave ? "bookmark.fill" : "bookmark")
                        .imageScale(.large)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 4)
            .foregroundStyle(.black)
            
            // likes label
            
            if post.likes > 0 {
                Text("\(post.likes) likes")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.top, 1)
            }
            
            // caption label
            
            HStack {
                Text("\(Text(post.user?.username ?? "").bold()) \(post.caption)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.footnote)
            .padding(.leading, 10)
            .padding(.top, 1)
            
            
            Text(post.timestamb.timestampString())
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.top, 1)
                .foregroundStyle(.gray)
        }
        .task { await viewModel.checkIfUserLikedPost(post) }
        .task { await viewModel.checkIfUserSavedPost(post) }
        .sheet(isPresented: $showComments) {
            CommentsView(post: post)
                .presentationDragIndicator(.visible)
        }
        .confirmationDialog("Post Options", isPresented: $showPostOptionsMenu, titleVisibility: .visible) {
            Button("Report", role: .destructive) {
                print("DEBUG: Show report sheet here..")
            }
        }
    }
}

private extension FeedCell {
    var postIndex: Int? {
        return viewModel.posts.firstIndex(where: { $0.id == post.id })
    }
    
    func handeleLikeTaped() {
        guard let postIndex else { return }
        Task {
            if viewModel.posts[postIndex].didLike {
                await viewModel.unlike(post)
            } else {
                await viewModel.like(post)
            }
        }
    }
    
    func handleSaveTapped() {
        guard let postIndex else { return }
        
        Task {
            if viewModel.posts[postIndex].didSave {
                await viewModel.unsave(post)
            } else {
                await viewModel.save(post)
            }
        }
    }
}

#Preview {
    FeedCell(
        post: MockData.posts[0],
        viewModel: FeedViewModel(
            feedService: FeedService(),
            userService: MockUserService(),
            likeService: MockLikePostService(),
            savePostService: MockSavePostService()
        )
    )
}
