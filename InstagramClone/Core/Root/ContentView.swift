//
//  ContentView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.04.2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var userManager: UserManager

    @StateObject var registrationViewModel = RegistrationViewModel(service: RegistrationValidationService())

    
    var body: some View {
        Group {
            if authManager.userSession == nil {
                LoginView()
                    .environmentObject(registrationViewModel)
            } else if userManager.currentUser != nil {
                MainTabView()
            }
        }
        .task(id: authManager.userSession) {
            guard authManager.userSession != nil else { return }
            await userManager.fetchCurrentUser()
        }
    }
}

#Preview {
    ContentView()
}
