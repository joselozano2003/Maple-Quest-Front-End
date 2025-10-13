//
//  MapPreview.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-13.
//

import SwiftUI
import MapKit
import Combine

struct MapPreview: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        )
    
    var body: some View {
        Map(position: $cameraPosition)
            .frame(height: 200)
            .cornerRadius(15)
            .shadow(radius: 5)
            .onReceive(locationManager.$userLocation.compactMap { $0 }) { loc in
                // Update camera to user location
                cameraPosition = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: loc,
                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                    )
                )
        }
    }
}

#Preview {
    MapPreview()
}
