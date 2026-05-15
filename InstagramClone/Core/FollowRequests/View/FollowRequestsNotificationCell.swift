//
//  FollowRequestsNotificationView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.05.2026.
//

import SwiftUI

struct FollowRequestsNotificationCell: View {
    @EnvironmentObject var viewModel: FollowRequestsViewModel

    var body: some View {
        NavigationLink {
            FollowRequestsView()
                .environmentObject(viewModel)
        } label: {
            VStack {
                HStack {
                    Text("Follow Requests")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    if !viewModel.requests.isEmpty {
                        Circle()
                            .fill(.blue)
                            .frame(width: 8, height: 8)
                    }
                    
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal)
                
                Divider()
            }
        }

    }
}

#Preview {
    FollowRequestsNotificationCell()
}
