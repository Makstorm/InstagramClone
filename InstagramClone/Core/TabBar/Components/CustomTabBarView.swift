//
//  CustomTabBarView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    var body: some View {
        HStack {
            ForEach(tabs.indices, id:\.self) { index in
                Spacer()
                
                CustomTabBarItemView(
                    item: tabs[index],
                    isSelected: selectedTab == index
                ) {
                    withAnimation(.spring) {
                        selectedTab = index
                    }
                }
                
                Spacer()
            }
        }
    }
}
