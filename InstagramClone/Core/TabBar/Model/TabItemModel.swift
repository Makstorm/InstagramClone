//
//  TabItemModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct TabItem {
    let icon: String
    let title: String?
    let content: AnyView
    
    init<Content: View>(
        icon: String,
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.title = title
        self.content = AnyView(content())
    }
    
    init<Content: View>(
        icon: String,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.title = nil
        self.content = AnyView(content())
    }
}
