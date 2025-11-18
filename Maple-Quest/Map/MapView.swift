//
//  MapView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var visitedLandmarks: [String]
    @EnvironmentObject var locationManager: LocationManager
    
    // Center map on Canada
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56.1304, longitude: -106.3468),
        span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
    )
    
    @State private var isInfoSelected: Bool = false
    
    var body: some View {
        NavigationStack {
            Map {
                ForEach(landmarks) { landmark in
                    Annotation(landmark.name, coordinate: landmark.location) {
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isInfoSelected = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $isInfoSelected) {
                InfoSheetView(isPresented: $isInfoSelected)
            }
        }
    }
}

struct InfoSheetView: View {
    @Binding var isPresented: Bool
    
    private let bullets = [
        "Explore popular Canadian landmarks marked with maple leaf pins!",
        "White maple leaves = landmarks waiting for you to discover, red maple leaves = landmarks you’ve already visited.",
        "Tap a landmark to see its details and snap some photos to remember your adventure!",
        "Make sure you’re within 500 meters of a landmark to unlock photo-adding magic.",
        "Use the gallery button to see all the photos you’ve captured at that landmark – your personal travel scrapbook!"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("How the Map Works")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 8)
                    
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

