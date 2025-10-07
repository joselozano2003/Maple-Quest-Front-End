//
//  ContentView.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 10/6/25.
//

// Hola 12244

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Home")
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            MapView()
            .tabItem {
                Label("Map", systemImage: "map.fill")
            }
            Text("Achievements")
            .tabItem {
                Label("Achievements", systemImage: "medal.fill")
            }
            Text("Profile")
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
