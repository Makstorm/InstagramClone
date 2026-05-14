//
//  SettingsView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 10.05.2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var userManager: UserManager
    
    @State private var isPrivateAccount = false
    @State private var showLogoutConfirmation = false
    @State private var showAllert = false
    
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
                        .tint(.blue)
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
//                        showLogoutConfirmation.toggle()
                        authManager.signOut()
                    }
                    
                    Button("Delete Account", role: .destructive) {
                        
                    }
                }
            }
            .onAppear(perform: onAppear)
            .alert("Unsaved Canges", isPresented: $showAllert) {
                Button("Cancel", role: .cancel) { }
                Button("Leave Without Saving", role: .destructive) { dismiss() }
            } message: {
                Text("Are you sure you want to exit witout saving?")
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
                    Button("Cancel", action: onCancel)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        updateUserPrivacyIfNecessary()
                    }
                }
            }
        }
    }
}

private extension SettingsView {
    var accountPrivacyDidChange: Bool {
        guard let currentUser = userManager.currentUser else { return false }
        
        return isPrivateAccount != currentUser.isPrivate
    }
    
    func onAppear() {
        self.isPrivateAccount = userManager.currentUser?.isPrivate ?? false
    }
    
    func onCancel() {
        if accountPrivacyDidChange {
            showAllert.toggle()
        } else {
            dismiss()
        }
    }

    func updateUserPrivacyIfNecessary() {
        guard accountPrivacyDidChange else {
            dismiss()
            return
        }
        
        Task {
            await userManager.updateAccountPrivacy(isPrivateAccount)
            dismiss()
        }
    }
}
