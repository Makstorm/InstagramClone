//
//  FollowRequestsView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.05.2026.
//

import SwiftUI

struct FollowRequestsView: View {
    @EnvironmentObject private var viewModel: FollowRequestsViewModel

    var body: some View {
        ScrollView {
            switch viewModel.loadingState {
            case .empty:
                IGContentUnavailableView(
                    "Nothing to see here.",
                    systemImage: "paperplane.circle",
                    description: "Follow requests will appear here when users request to follow you account."
                )
                .containerRelativeFrame(.vertical)
            case .error:
                Text("An error occured.")
            case .loading:
                ProgressView()
                    .containerRelativeFrame(.vertical)
            case .complete:
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.requests) { request in
                        FollowRequestCell(request: request)
                    }
                }
            }
        }
        .navigationTitle("Follow Requests")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.vertical)
    }
}

#Preview {
    NavigationStack {
        FollowRequestsView()
    }
}
