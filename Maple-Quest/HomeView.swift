//
//  HomeView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        // Home view title
        VStack(alignment: .leading) {
            Text("Explore")
            HStack {
                Text("Beautiful").bold()
                Text("Canada!").bold().foregroundColor(.red)
            }
        }
        .font(.largeTitle)
        .padding()
        
        VStack(alignment: .leading) {
            Text("Welcome, ...!")
                .font(.system(size: 22)).bold()
            Text("You have visited ... Canadian landmarks!")
                .font(.subheadline)
            Text("Explore Landmarks Near You")
                .font(.system(size: 22)).bold()
            Text("Highlights")
                .font(.system(size: 22)).bold()
        }
    }
}

#Preview {
    HomeView()
}
