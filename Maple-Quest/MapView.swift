//
//  MapView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    let niagraFalls = CLLocationCoordinate2D(
        latitude: 43.09468530054129,
        longitude: -79.03996936268442
    )
    
    let banff = CLLocationCoordinate2D(
        latitude: 51.497407682404955,
        longitude: -115.9261679966291
    )
    
    let hopewellRocks = CLLocationCoordinate2D(
        latitude: 45.817654979524015,
        longitude: -64.57845776218284
    )
    
    
    var body: some View {
        Map() {
            Marker("Niagara Falls", coordinate: niagraFalls)
            Marker("Banff National Park", coordinate: banff)
            Marker("HopeWell Rocks Provincial Park", coordinate: hopewellRocks)
        }
         
    }
}

#Preview {
    MapView()
}
