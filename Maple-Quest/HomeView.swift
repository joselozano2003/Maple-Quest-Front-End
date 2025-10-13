//
//  HomeView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI

struct HomeView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // Title Section
                VStack(alignment: .leading) {
                    Text("Explore")
                    HStack {
                        Text("Beautiful").bold()
                        Text("Canada!").bold().foregroundColor(.red)
                    }
                }
                .font(.largeTitle)
                .padding(.top, 50)
                
                VStack(alignment: .leading) {
                    // Mini summary section
                    Text("Welcome, \(user.firstName)!")
                        .font(.system(size: 22)).bold()
                        .padding(.top)
                    Text("You have visited 0 of \(landmarks.count) Canadian landmarks!")
                        .font(.subheadline)
                    // Mini map view of landmarks nearby
                    Text("Explore Landmarks Near You")
                        .font(.system(size: 22)).bold()
                        .padding(.top)
                    MapPreview()
                    // Top landmarks in Canada
                    Text("Highlights")
                        .font(.system(size: 22)).bold()
                        .padding(.top)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    HomeView(user: .sample)
}
