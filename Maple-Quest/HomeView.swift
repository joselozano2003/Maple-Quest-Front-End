//
//  HomeView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI

struct HomeView: View {
    let user: User
    // This property receives the visited count from ContentView
    let visitedCount: Int
    
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
                    // This now displays the correct visited count
                    Text("You have visited \(visitedCount) of \(landmarks.count) Canadian landmarks!")
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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(landmarks) { landmark in
                                VStack(alignment: .leading) {
                                    Image(landmark.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 250, height: 160)
                                        .cornerRadius(15)
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                                    
                                    Text(landmark.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text(landmark.province)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .padding(.horizontal, -20)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    HomeView(user: .sample, visitedCount: 0)
}

