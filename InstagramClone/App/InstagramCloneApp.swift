//
//  InstagramCloneApp.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.04.2026.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct InstagramCloneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthManager(service: AuthService())
    @StateObject private var userManager = UserManager(service: UserService())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(userManager)
        }
    }
}
