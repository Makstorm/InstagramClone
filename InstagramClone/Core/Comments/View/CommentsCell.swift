//
//  CommentsCell.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 22.04.2026.
//

import SwiftUI

struct CommentsCell: View {
    let commnet: Comment
    
    private var user: User? {
        return commnet.user
    }
    
    var body: some View {
        HStack {
            CircularProfileImageView(user: user, size: .xSmall)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 2) {
                    Text(user?.username ?? "")
                        .fontWeight(.semibold)
                    
                    Text(commnet.timestamp.timestampString())
                        .foregroundStyle(.gray)
                }
                
                Text(commnet.commnetText)
            }
            .font(.caption)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    CommentsCell(commnet: DeveloperPreview.shared.comment)
}
