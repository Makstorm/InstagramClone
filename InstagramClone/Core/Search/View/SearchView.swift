//
//  SearchView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @StateObject var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            UserListView(config: .explore)
                .navigationDestination(
                    for: User.self,
                    destination: { user in
                        ProfileView(user: user)
                    }
                )
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SearchView()
}
