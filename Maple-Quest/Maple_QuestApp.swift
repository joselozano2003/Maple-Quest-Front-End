//
//  Maple_QuestApp.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 10/6/25.
//

import SwiftUI

@main
struct Maple_QuestApp: App {
    @StateObject private var authService = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !authService.isInitialized {
                    SplashView()
                } else if authService.isAuthenticated {
                    ContentView()
                        .environmentObject(authService)
                } else {
                    LoginView()
                        .environmentObject(authService)
                }
            }
        }
    }
}
