//
//  CustomTabBarView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct CustomTabBarContainer: View {
    @StateObject private var router: TabRouter
    let tabs: [TabItem]
    
    init(tabs: [TabItem]) {
        self.tabs = tabs
        self._router = StateObject<TabRouter>(wrappedValue: TabRouter(tabs: tabs))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if !tabs.isEmpty {
                //Content
                tabs[router.selectedTab].content
                    .environmentObject(router)

                //CustomTabBar
                CustomTabBarView(selectedTab: $router.selectedTab, tabs: tabs)
                    .padding(.top, 8)
                    .background(Color(.systemBackground))
            }
        }
    }
}
