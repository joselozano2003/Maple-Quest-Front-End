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
        .onChange(of: visitedLandmarks) { _, _ in
            saveVisitedLandmarks()
        }
    }
    
    // The logic for saving and loading is now in this central view
    func saveVisitedLandmarks() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(visitedLandmarks) {
            UserDefaults.standard.set(encoded, forKey: "visitedLandmarks")
        }
    }
    
    func loadVisitedLandmarks() {
        if let savedData = UserDefaults.standard.data(forKey: "visitedLandmarks") {
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
}
