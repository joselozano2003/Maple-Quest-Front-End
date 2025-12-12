//
//  ContentView.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 10/6/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    
    // The list of visited landmarks is now managed here
    @State private var visitedLandmarks: [String] = []
    // The location manager is now created here and shared with other views
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        TabView {
            if let currentUser = authService.currentUser {
                // Wrap HomeView in a NavigationStack to allow navigation
                NavigationStack {
                    HomeView(
                        user: currentUser,
                        visitedCount: visitedLandmarks.count,
                        visitedLandmarks: $visitedLandmarks // Pass the binding
                    )
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                // Pass a binding to the visited landmarks array to the MapView
                MapView(visitedLandmarks: $visitedLandmarks)
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }
                
                // Pass a binding to the AchievementsView so it can check progress
                AchievementsView(visitedLandmarks: $visitedLandmarks)
                    .tabItem {
                        Label("Achievements", systemImage: "medal.fill")
                    }
                
                ProfileView(user: .constant(currentUser))
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
        }
        .tint(.red)
        // Make the location manager available to all child views
        .environmentObject(locationManager)
        .onAppear {
            loadVisitedLandmarks()
        }
        // --- SYNC LOGIC ---
        .onChange(of: visitedLandmarks) { _, newLandmarks in
            // 1. Save locally (so user sees it offline)
            saveVisitedLandmarks()
            
            // 2. Sync to Server (so friends see it on leaderboard)
            Task {
                do {
                    // We send the count (e.g. 1, 5, 10) as the points
                    try await APIService.shared.updatePoints(points: newLandmarks.count)
                } catch {
                    print("⚠️ Failed to sync points to server: \(error.localizedDescription)")
                }
            }
        }
        // ------------------
    }
    
    // Persistence Logic
    
    // Generates a unique key for the current user (e.g., "visitedLandmarks_john@email.com")
    private var userDataKey: String {
        guard let userId = authService.currentUser?.email else {
            return "visitedLandmarks_guest"
        }
        return "visitedLandmarks_\(userId)"
    }
    
    func saveVisitedLandmarks() {
        guard authService.currentUser != nil else { return }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(visitedLandmarks) {
            UserDefaults.standard.set(encoded, forKey: userDataKey)
        }
    }
    
    func loadVisitedLandmarks() {
        // 1. Clear the list first to remove any data from a previous user
        visitedLandmarks = []
        
        // 2. Load data specifically for this user
        if let savedData = UserDefaults.standard.data(forKey: userDataKey) {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([String].self, from: savedData) {
                visitedLandmarks = loaded
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService.shared)
}
