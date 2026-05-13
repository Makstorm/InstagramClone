//
//  UserStatView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct UserStatView: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(title)
                .font(.footnote)
        }
        .foregroundStyle(Color(.primaryText))
        .opacity(value == 0 ? 0.5 : 1.0)
        .frame(width: 72)
    }
}

#Preview {
    UserStatView(title: "Posts", value: 3)
}
