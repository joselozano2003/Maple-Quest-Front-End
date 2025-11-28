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
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                } else {
                    if authService.isAuthenticated {
                        ContentView()
                            .environmentObject(authService)
                    } else {
                        LoginView()
                            .environmentObject(authService)
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
    }
}
