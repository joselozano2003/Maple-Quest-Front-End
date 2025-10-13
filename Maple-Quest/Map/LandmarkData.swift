//
//  LandmarkData.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-13.
//

import CoreLocation
import Foundation

let landmarks: [Landmark] = [
    Landmark(
        name: "Niagara Falls",
        province: "Ontario",
        description: "One of the most famous waterfalls in the world...",
        imageName: "niagaraFalls",
        location: CLLocationCoordinate2D(latitude: 43.0946853, longitude: -79.039969),
        isVisited: false
    ),
    Landmark(
        name: "Hopewell Rocks Provincial Park",
        province: "New Brunswick",
        description: "Known for its flowerpot rock formations...",
        imageName: "hopewellRocks",
        location: CLLocationCoordinate2D(latitude: 45.817655, longitude: -64.578458),
        isVisited: false
    ),
    Landmark(
        name: "Banff National Park",
        province: "Alberta",
        description: "Nestled in the heart of the Canadian Rockies...",
        imageName: "banff",
        location: CLLocationCoordinate2D(latitude: 51.497408, longitude: -115.926168),
        isVisited: false
    )
]
