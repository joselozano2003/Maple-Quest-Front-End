//
//  ContentView.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 10/6/25.
//


import SwiftUI

struct ContentView: View {
    
    // Hardcoded user to make testing easier
    let currentUser = User.sample
    // The list of visited landmarks is now managed here
    @State private var visitedLandmarks: [String] = []
    // The location manager is now created here and shared with other views
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        TabView {
            // Pass the count of visited landmarks to the HomeView
            HomeView(user: currentUser, visitedCount: visitedLandmarks.count)
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
            ProfileView(user: currentUser)
            .tabItem {
                Label("Profile", systemImage: "person.fill")
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

#Preview {
    ContentView()
}

