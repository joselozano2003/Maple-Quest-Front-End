//
//  MapView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI
import MapKit

let landmarks = [
    Landmark(
        name: "Niagara Falls",
        province: "Ontario",
        description: "One of the most famous waterfalls in the world, Niagara Falls offers breathtaking views and thrilling boat rides.",
        imageName: "niagara",
        location: CLLocationCoordinate2D(
            latitude: 43.09468530054129,
            longitude: -79.03996936268442
        )
    ),
    Landmark(
        name: "Hopewell Rocks Provincial Park",
        province: "New Brunswick",
        description: "Known for its flowerpot rock formations, Hopewell Rocks is a must-see tidal wonder on the Bay of Fundy.",
        imageName: "hopewell",
        location: CLLocationCoordinate2D(
            latitude: 45.817654979524015,
            longitude: -64.57845776218284
        )
    ),
    Landmark(
        name: "Banff National Park",
        province: "Alberta",
        description: "Nestled in the heart of the Canadian Rockies, Banff is known for its turquoise lakes, majestic mountain peaks, and endless outdoor adventures.",
        imageName: "banff",
        location: CLLocationCoordinate2D(
            latitude: 51.497407682404955,
            longitude: -115.9261679966291
        )
    )
]

struct MapView: View {
    
    @State private var selectedLandmark: Landmark? = nil
    
    var body: some View {
        Map {
            ForEach(landmarks) { landmark in
                Annotation(landmark.name, coordinate: landmark.location) {
                    Button {
                        selectedLandmark = landmark
                    } label: {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
                
            }
        }
        .fullScreenCover(item: $selectedLandmark) { landmark in
            LocationDetailView(landmark: landmark)
        }
    }
}

#Preview {
    MapView()
}
