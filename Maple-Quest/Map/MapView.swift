//
//  MapView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI
import MapKit

struct MapView: View {
    // This is now a binding to the state in ContentView
    @Binding var visitedLandmarks: [String]
    // Get the location manager from the environment
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationStack {
            Map {
                ForEach(landmarks) { landmark in
                    Annotation(landmark.name, coordinate: landmark.location) {
                        NavigationLink {
                            // Pass the user's current location to the detail view
                            LocationDetailView(landmark: landmark, userLocation: locationManager.userLocation) { visited in
                                if visited && !visitedLandmarks.contains(landmark.name) {
                                    visitedLandmarks.append(landmark.name)
                                }
                            }
                        } label: {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(visitedLandmarks.contains(landmark.name) ? .orange : .red)
                                .shadow(color: .white, radius: 2, x: 0, y: 0)
                        }
                    }
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

