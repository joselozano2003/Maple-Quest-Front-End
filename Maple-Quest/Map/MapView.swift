//
//  MapView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    // Variables
    @Binding var visitedLandmarks: [String]
    @EnvironmentObject var locationManager: LocationManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56.1304, longitude: -106.3468),
        span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
    ) // Centers the map around Canada
    @State private var isInfoSelected: Bool = false
    @State private var isListSelected: Bool = false
    
    // View
    var body: some View {
        NavigationStack {
            Map {
                ForEach(landmarks) { landmark in
                    Annotation(landmark.name, coordinate: landmark.location) {
                        
                        // Click on a map pin to navigate to the detail screen
                        // Update the visited list if the landmark gets marked as visited.
                        NavigationLink {
                            LocationDetailView(landmark: landmark, userLocation: locationManager.userLocation) { visited in
                                if visited && !visitedLandmarks.contains(landmark.name) {
                                    visitedLandmarks.append(landmark.name)
                                }
                            }
                        } label: {
                            Image(visitedLandmarks.contains(landmark.name) ? "map-pin-visited" : "map-pin-unvisited")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                        }
                    }
                }
            }
            
            // Button to navigate to the user's current location
            .mapControls {
                MapUserLocationButton()
            }
            
            // Information and landmark list view buttons
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isInfoSelected = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isListSelected = true
                    } label: {
                        Image(systemName: "list.bullet.circle")
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $isInfoSelected) {
                InfoSheetView(isPresented: $isInfoSelected)
            }
            .fullScreenCover(isPresented: $isListSelected) {
                LandmarkListView(
                    isPresented: $isListSelected,
                    visitedLandmarks: visitedLandmarks,
                    allLandmarks: landmarks
                )
            }

        }
    }
}

// Function to filter landmarks in list view
enum LandmarkFilter: String, CaseIterable {
    case all = "All Landmarks"
    case visited = "Visited Landmarks"
    case unvisited = "Unvisited Landmarks"
    
    var icon: Image {
        switch self {
        case .all: return Image(systemName: "map.circle")
            case .visited: return Image(systemName: "mappin.circle")
            case .unvisited: return Image(systemName: "mappin.slash.circle")
        }
    }
}

struct LandmarkListView: View {
    
    // Variables
    @Binding var isPresented: Bool
    var visitedLandmarks: [String]
    var allLandmarks: [Landmark]
    @State private var filter: LandmarkFilter = .all
    var filteredLandmarks: [Landmark] {
        switch filter {
        case .all:
            return allLandmarks
        case .visited:
            return allLandmarks.filter { visitedLandmarks.contains($0.name) }
        case .unvisited:
            return allLandmarks.filter { !visitedLandmarks.contains($0.name) }
        }
    }

    // View
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    
                    // Displays each landmark as a card
                    ForEach(filteredLandmarks) { landmark in
                        HStack(spacing: 12) {
                            
                            // Thumbnail image
                            Image(landmark.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 60)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            
                            // Landmark name and province where its located
                            VStack(alignment: .leading, spacing: 4) {
                                Text(landmark.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(landmark.province)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Distinguishes which landmarks have been visited
                            Image(systemName: visitedLandmarks.contains(landmark.name) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(visitedLandmarks.contains(landmark.name) ? .red : .gray)
                        }
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                    }
                }
                .padding()
            }
            .navigationTitle(filterTitle())
            .toolbar {
                // Landmark filter
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(LandmarkFilter.allCases, id: \.self) { option in
                            Button {
                                filter = option
                            } label: {
                                HStack {
                                    option.icon
                                    Text(option.rawValue)
                                }
                            }
                            .tint(.red)
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                
                // Button to close landmark list view
                ToolbarItem(placement: .bottomBar) {
                    Button("Done") {
                        isPresented = false
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    // Filter titles
    func filterTitle() -> String {
        switch filter {
            case .all: return "All Landmarks"
            case .visited: return "Visited Landmarks"
            case .unvisited: return "Unvisited Landmarks"
        }
    }
}

struct InfoSheetView: View {
    
    // Variables
    @Binding var isPresented: Bool
    private let bullets = [
        "Explore popular Canadian landmarks marked with maple leaf pins!",
        "White maple leaves = landmarks waiting for you to discover, red maple leaves = landmarks you’ve already visited.",
        "Tap a landmark to see its details and snap some photos to remember your adventure!",
        "Make sure you’re within 500 meters of a landmark to unlock photo-adding magic.",
        "Use the gallery button to see all the photos you’ve captured at that landmark – your personal travel scrapbook!"
    ]
    
    // View
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("How the Map Works")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 8)
                    
                    // Bullet points for some guidelines on how the map works
                    VStack(spacing: 16) {
                        ForEach(bullets, id: \.self) { bullet in
                            Text(bullet)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Instructions")
            .toolbar {
                
                // Button to close the information page
                ToolbarItem(placement: .bottomBar) {
                    Button("Got it!") {
                        isPresented = false
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                }
            }
        }
    }
}


#Preview {
    // The preview needs a constant binding and a location manager to work
    MapView(visitedLandmarks: .constant([]))
        .environmentObject(LocationManager())
}

