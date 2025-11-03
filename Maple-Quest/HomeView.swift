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
    // Add binding to update landmarks
    @Binding var visitedLandmarks: [String]
    // Get location manager from environment
    @EnvironmentObject var locationManager: LocationManager
    
    // Calculate progress for the progress bar
    private var progress: Double {
        // Ensure landmarks.count is not zero to avoid division by zero
        guard !landmarks.isEmpty else { return 0.0 }
        return Double(visitedCount) / Double(landmarks.count)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // Title Section
                VStack(alignment: .leading) {
                    Text("Explore")
                    HStack {
                        Text("Beautiful").bold()
                        Text("Canada!").bold().foregroundColor(.red)
                        
                        // Add a thematic maple leaf icon
                        Image("maple-leaf-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.leading, 4)
                    }
                }
                .font(.largeTitle)
                .padding(.top, 50)
                
                VStack(alignment: .leading) {
                    
    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome, \(user.firstName)!")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        // Custom Progress Bar
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Progress: \(visitedCount) of \(landmarks.count) landmarks visited")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            ProgressView(value: progress)
                                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                                .animation(.spring(), value: visitedCount)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading) // Make it full width
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.top)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.title3)
                            .foregroundColor(.red)
                        Text("Explore Landmarks Near You")
                            .font(.system(size: 22)).bold()
                    }
                    .padding(.top)
                    
                    MapPreview()

                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.title3)
                            .foregroundColor(.yellow)
                        Text("Highlights")
                            .font(.system(size: 22)).bold()
                    }
                    .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(landmarks) { landmark in
                                // Wrap the card in a NavigationLink
                                NavigationLink {
                                    // Destination is the LocationDetailView
                                    LocationDetailView(
                                        landmark: landmark,
                                        userLocation: locationManager.userLocation,
                                        onVisited: { visited in
                                            if visited && !visitedLandmarks.contains(landmark.name) {
                                                visitedLandmarks.append(landmark.name)
                                            }
                                        }
                                    )
                                } label: {
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
    HomeView(
        user: .sample,
        visitedCount: 1,
        visitedLandmarks: .constant(["Niagara Falls"])
    )
    .environmentObject(LocationManager())
}
