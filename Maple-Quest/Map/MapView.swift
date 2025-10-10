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
        imageName: "niagaraFalls",
        location: CLLocationCoordinate2D(
            latitude: 43.09468530054129,
            longitude: -79.03996936268442
        ),
        isVisited: false
    ),
    Landmark(
        name: "Hopewell Rocks Provincial Park",
        province: "New Brunswick",
        description: "Known for its flowerpot rock formations, Hopewell Rocks is a must-see tidal wonder on the Bay of Fundy.",
        imageName: "hopewellRocks",
        location: CLLocationCoordinate2D(
            latitude: 45.817654979524015,
            longitude: -64.57845776218284
        ),
        isVisited: false
    ),
    Landmark(
        name: "Banff National Park",
        province: "Alberta",
        description: "Nestled in the heart of the Canadian Rockies, Banff is known for its turquoise lakes, majestic mountain peaks, and endless outdoor adventures.",
        imageName: "banff",
        location: CLLocationCoordinate2D(
            latitude: 51.497407682404955,
            longitude: -115.9261679966291
        ),
        isVisited: false
    )
]

struct MapView: View {
    @State private var visitedLandmarks: Set<String> = []
    var body: some View {
        NavigationStack {
            Map {
                ForEach(landmarks) { landmark in
                    Annotation(landmark.name, coordinate: landmark.location) {
                        NavigationLink {
                            LocationDetailView(landmark: landmark) { visited in
                                if visited {
                                    visitedLandmarks.insert(landmark.name)
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
    MapView()
}
