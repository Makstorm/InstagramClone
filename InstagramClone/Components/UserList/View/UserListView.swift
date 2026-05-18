//
//  UserListView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 23.04.2026.
//

import SwiftUI

struct UserListView: View {
    @State private var searchText = ""
    @StateObject var viewModel = UserListViewModel(service: UserListService(userService: UserService()))
    
    @State private var activeScrollId: String?
    @State private var paginating = false
    
    private let config: UserListConfiguration
    
    init(config: UserListConfiguration) {
        self.config = config
    }
    
    var body: some View {
        ScrollView {
            switch self.viewModel.loadingState {
            case .empty:
                Text("Empty state.")
            case .error:
                Text("An error occurred.")
            case .loading:
                ProgressView()
            case .complete:
                LazyVStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.small)
                        
                        TextField("Seacrch...", text: $searchText)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    
                    
                    ForEach(filteredUsers) { user in
                        NavigationLink(value: user) {
                            UserCell(user: user)
                        }
                        .id(user.id)
                    }
                    if paginating { ProgressView() }
                }
                .scrollTargetLayout()
                .padding(.top, 8)
            }
        }
        .scrollPosition(id: $activeScrollId, anchor: .bottom)
        .onChange(of: activeScrollId, { oldValue, newValue in
            loadMoreUsersIfNecessary(newValue)
        })
        .navigationDestination(for: User.self, destination: { user in
            ProfileView(user: user)
        })
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchUser(forConfig: config)
        }
    }
}

private extension UserListView {
    struct UserCell: View {
        let user: User
        
        var body: some View {
            HStack {
                CircularProfileImageView(user: user, size: .xSmall)
                
                VStack(alignment: .leading) {
                    Text(user.username)
                        .fontWeight(.semibold )
                    if let fullname = user.fullname {
                        Text(fullname)
                    }
                }
                .font(.footnote)
                
                Spacer()
            }
            .foregroundStyle(.black)
            .padding(.horizontal)
        }
    }
}

private extension UserListView {
    var filteredUsers: [User] {
        let query = searchText.lowercased()
        
        if searchText.isEmpty {
            return viewModel.users
        } else {
            return viewModel.users.filter {
                $0.username.lowercased().contains(query)
            }
        }
    }
    func loadMoreUsersIfNecessary(_ activeScrollId: String?) {
        guard activeScrollId == viewModel.users.last?.id else { return }
        
        Task {
            paginating = true
            await viewModel.fetchUser(forConfig: config)
            paginating = false
        }
    }
}

#Preview {
    UserListView(config: .explore)
}
