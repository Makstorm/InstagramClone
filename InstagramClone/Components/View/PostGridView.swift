//
//  PostGridView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import SwiftUI
import Kingfisher

struct PostGridView: View {
    @StateObject var viewModel: PostGrigViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: PostGrigViewModel(user: user))
    }
    
    
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
    ]
    
    private let imageDimention: CGFloat = (UIScreen.main.bounds.width / 3) - 1
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 1) {
            ForEach(viewModel.posts) { post in
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageDimention, height: imageDimention)
                    .clipped()
            }
        }
    }
}

#Preview {
    PostGridView(user: User.MOCK_USERS[0])
}
