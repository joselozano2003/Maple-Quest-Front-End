//
//  HomeView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    let user: User
    let visitedCount: Int
    @Binding var visitedLandmarks: [String]
    @EnvironmentObject var locationManager: LocationManager
    
    // Calculate progress for the progress bar
    private var progress: Double {
        guard !landmarks.isEmpty else { return 0.0 }
        return Double(visitedCount) / Double(landmarks.count)
    }
    
    // Top 3 nearby landmarks
    private var nearbyLandmarks: [Landmark] {
        guard let userLocation = locationManager.userLocation else { return [] }

        return landmarks
            .map { landmark in
                (landmark, CLLocation(latitude: landmark.location.latitude, longitude: landmark.location.longitude)
                    .distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)))
            }
            .sorted { $0.1 < $1.1 }
            .prefix(3)
            .map { $0.0 }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "EAF6FF")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    // Title Section
                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .offset(y: 30)
                    
                    VStack(alignment: .leading) {
                        ZStack {
                            Text("Explore")
                            Image("cloud")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 35)
                                .offset(x: 250, y: -10)
                        }
                        HStack {
                            Text("Beautiful").bold()
                            Text("Canada!").bold().foregroundColor(.red)
                            Image("maple-leaf-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(.leading, 4)
                        }
                        .padding(.top, -10)
                    }
                    .font(.largeTitle)
                    
                    VStack(alignment: .leading) {
                        // Welcome + Progress Bar
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome, \(user.firstName)!")
                                .font(.title2)
                                .fontWeight(.bold)
                            
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cornerRadius(15)
                        .padding(.horizontal, -15)
                        
                        // Explore Landmarks Near You Header
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.title3)
                                .foregroundColor(.red)
                            Text("Explore Landmarks Near You")
                                .font(.system(size: 22)).bold()
                        }
                        .padding(.top)
                        
                        // Top 3 Nearby Landmarks List
                        VStack(spacing: 12) {
                            ForEach(nearbyLandmarks) { landmark in
                                HStack(spacing: 12) {
                                    Image(landmark.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 60)
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(landmark.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(landmark.province)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        if let userLocation = locationManager.userLocation {
                                            let distance = Int(
                                                CLLocation(latitude: landmark.location.latitude,
                                                           longitude: landmark.location.longitude)
                                                    .distance(from: CLLocation(latitude: userLocation.latitude,
                                                                               longitude: userLocation.longitude)) / 1000
                                            )
                                            Text("\(distance) km away")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: visitedLandmarks.contains(landmark.name) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(visitedLandmarks.contains(landmark.name) ? .red : .gray)
                                }
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                            }
                        }

                        .padding(.vertical)
                        
                        // Highlights Header
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.title3)
                                .foregroundColor(.red)
                            Text("Highlights")
                                .font(.system(size: 22)).bold()
                        }
                        .padding(.top)
                        
                        // Highlights Carousel
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(landmarks) { landmark in
                                    NavigationLink {
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
            .ignoresSafeArea()
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
