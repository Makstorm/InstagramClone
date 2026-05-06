//
//  EmptyStateView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 05.05.2026.
//

import SwiftUI

struct EmptyStateView: View {
    private let title: String
    private let systemImage: String
    private let description: String
    
    init(_ title: String, systemImage: String, description: String) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
    }
    
    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .resizable()
                .frame(width: 100, height: 100)
                .fontWeight(.ultraLight)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(description)
                .foregroundStyle(.gray)
                .font(.subheadline)
                .padding(.horizontal, 32)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    EmptyStateView(
        "Preview",
        systemImage: "bubble.circle",
        description: "Nothing to see here..."
    )
}
