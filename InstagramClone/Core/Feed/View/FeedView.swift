//
//  FeedView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel(
        feedService: FeedService(),
        userService: UserService(),
        likePostService: LikePostService(),
        savePostService: SavePostService()
    )
    
    @State private var activeScrollId: String?
    @State private var paginating = false
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .empty:
                    Text("Empty state goes here")
                case .error:
                    Text("An error occurred.")
                case .loading:
                    ProgressView()
                case .complete:
                    ScrollView {
                        LazyVStack(spacing: 32) {
                            ForEach(viewModel.posts) { post in
                                FeedCell(post: post, viewModel: viewModel)
                            }
                            
                            if paginating {
                                ProgressView()
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.top, 8)
                    }
                    .scrollPosition(id: $activeScrollId, anchor: .bottom)
                }
            }
            .onChange(of: activeScrollId, { oldValue, newValue in
                loadMorePosts(newValue)
            })
            .refreshable { await viewModel.refreshPosts() }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: FeedRouter.self) { route in
                route.view
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.instagramLogoBlack)
                        .resizable()
                        .frame(width: 100, height: 32)
                }
                .sharedBackgroundVisibility(.hidden)

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: FeedRouter.inbox) {
                        Image(systemName: "paperplane")
                            .imageScale(.large)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
}

private extension FeedView {
    func loadMorePosts(_ activeScrollId: String?) {
        Task {
            guard activeScrollId == viewModel.posts.last?.id else { return }
            paginating = true
            await viewModel.fetchPosts()
            paginating = false
        }
    }
}

#Preview {
    FeedView()
}
