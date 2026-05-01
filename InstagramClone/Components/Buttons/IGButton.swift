//
//  IGButton.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 30.04.2026.
//

import SwiftUI

struct IGButton: View {
    private let title: String
    private let action: () -> Void
    private let isLoading: Bool
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.isLoading = false
    }

    init(_ title: String, isLoading: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action 
    }

    var body: some View {
        Button { action() } label: {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                }
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(width: 360, height: 44)
            .background(Color(.systemBlue))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    IGButton("Test", action: {})
}
