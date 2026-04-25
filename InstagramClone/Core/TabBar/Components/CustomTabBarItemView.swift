//
//  CustomTabBarItem.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct CustomTabBarItemView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let item: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: item.icon)
                .font(.title2)
                .foregroundStyle(foregroundColor)
            if let text = item.title {
                Text(text)
            }
        }
    }
    
    private var foregroundColor: Color {
            if isSelected {
                return colorScheme == .dark ? .white : .black
            } else {
                return colorScheme == .dark ? .gray : .secondary
            }
        }
}
