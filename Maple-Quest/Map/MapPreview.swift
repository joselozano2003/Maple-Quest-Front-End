//
//  MapPreview.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-13.
//

import SwiftUI
import MapKit

struct MapPreview: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.0447, longitude: -114.0611), // Default Calgary
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        )
    
    var body: some View {
        Map() {}
        .frame(height: 200)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    MapPreview()
}
