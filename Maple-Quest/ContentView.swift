//
//  ContentView.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 10/6/25.
//


import SwiftUI

struct ContentView: View {
    
    // Hardocoded user to make testing easier
    let currentUser = User.sample
    
    var body: some View {
        TabView {
            HomeView()
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            MapView()
            .tabItem {
                Label("Map", systemImage: "map.fill")
            }
            AchievementsView()
            .tabItem {
                Label("Achievements", systemImage: "medal.fill")
            }
            ProfileView(user: currentUser)
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .tint(.red)
    }
}

#Preview {
    ContentView()
}
