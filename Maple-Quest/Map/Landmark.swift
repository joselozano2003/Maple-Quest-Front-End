//
//  Landmark.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-07.
//

import CoreLocation

struct Landmark: Identifiable {
    var id = UUID().uuidString
    var name: String
    var province: String
    var country = "Canada"
    var description: String
    var imageName: String
    var location: CLLocationCoordinate2D
}

