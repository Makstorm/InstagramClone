//
//  SettingsView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 10.05.2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var userManager: UserManager
    
    @State private var isPrivateAccount = false
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        CircularProfileImageView(user: userManager.currentUser, size: .large)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userManager.currentUser?.fullname ?? "")
                                .fontWeight(.semibold)
                            Text(userManager.currentUser?.email ?? "")
                                .font(.footnote)
                                .tint(.gray)
                        }
                    }
                }
                
                Section("Privacy") {
                    Toggle("Private Accoutn", isOn: $isPrivateAccount)
                    Text("Blocked Accounts")
                }
                
                Section("Activity") {
                    ForEach(SettingsActivitySectionModel.allCases) { model in
                        NavigationLink(value: model) {
                            Text(model.description)
                        }
                    }
                }
                
                Section("Legal") {
                    Text("Terms & Conditions")
                }
                
                Section("Account") {
                    Button("Log Out", role: .destructive) {
                        showLogoutConfirmation.toggle()
                    }
                    
                    Button("Delete Account", role: .destructive) {
                        
                    }
                }
            }
            .sheet(isPresented: $showLogoutConfirmation) {
                Text("Here must be a log out view...")
            }
            .navigationDestination(for: SettingsActivitySectionModel.self) { model in
                switch model {
                case .savedPosts:
                    SavedPostsView()
                case .likePosts:
                    LikedPostsView()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        print("DEBUG: Update user info here")
                    }
                }
            }
        }
    }
}
