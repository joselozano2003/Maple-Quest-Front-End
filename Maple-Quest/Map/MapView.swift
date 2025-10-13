//
//  MapView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var visitedLandmarks: [String] = []
    var body: some View {
        NavigationStack {
            Map {
                ForEach(landmarks) { landmark in
                    Annotation(landmark.name, coordinate: landmark.location) {
                        NavigationLink {
                            LocationDetailView(landmark: landmark) { visited in
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
            .onAppear {
                loadVisitedLandmarks()
            }
            .onChange(of: visitedLandmarks) { _, _ in
                saveVisitedLandmarks()
            }
        }
    }
    
    func saveVisitedLandmarks() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(visitedLandmarks) {
            UserDefaults.standard.set(encoded, forKey: "visitedLandmarks")
        }
    }
    
    func loadVisitedLandmarks() {
        if let savedData = UserDefaults.standard.data(forKey: "visitedLandmarks") {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([String].self, from: savedData) {
                visitedLandmarks = loaded
            }
        }
    }
}

#Preview {
    MapView()
}
