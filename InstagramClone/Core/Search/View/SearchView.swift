//
//  SearchView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            UserListView(config: .explore)
                
        }
    }
}

#Preview {
    SearchView()
}
