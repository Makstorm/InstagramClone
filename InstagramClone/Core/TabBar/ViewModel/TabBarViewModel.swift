//
//  TabBarViewModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 18.04.2026.
//

import SwiftUI
import Combine

class TabRouter: ObservableObject {
    @Published var selectedTab: Int = 0
    
    let tabs: [TabItem]
    
    init(tabs: [TabItem]) {
        self.tabs = tabs
    }
    
    func goTo(_ tab: Int) {
        guard tab < tabs.count else { return }
        selectedTab = tab
    }
}
