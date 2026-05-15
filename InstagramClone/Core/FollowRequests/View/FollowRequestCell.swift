//
//  FollowRequestCell.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.05.2026.
//

import SwiftUI

struct FollowRequestCell: View {
    @EnvironmentObject private var viewModel: FollowRequestsViewModel
    let request: FollowRequest

    var body: some View {
        HStack {
            CircularProfileImageView(user: request.user, size: .medium)
            
            VStack(alignment: .leading, spacing: 2) {
                if let user = request.user {
                    Text(user.username)
                        .fontWeight(.semibold)
                    
                    if let fullname = user.fullname {
                        Text(fullname)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .font(.subheadline)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    Task { await viewModel.accept(request) }
                } label: {
                        Text("Accept")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 88, height: 34)
                            .background(.blue)
                            .clipShape(.rect(cornerRadius: 6))
                    }
                
                Button {
                    Task { await viewModel.reject(request) }
                } label: {
                        Text("Reject")
                            .foregroundStyle(Color(.primaryText))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 88, height: 34)
                            .background(Color(.secondarySystemFill))
                            .clipShape(.rect(cornerRadius: 6))
                    }
            }
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    FollowRequestCell(request: MockData.followRequests[0])
}
