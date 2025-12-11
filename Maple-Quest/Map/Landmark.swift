//
//  Landmark.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-07.
//

import CoreLocation

// Model representing a Canadian landmark
struct Landmark: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var name: String
    var province: String
    var country = "Canada"
    var description: String
    var imageName: String
    var location: CLLocationCoordinate2D
    var isVisited: Bool
    
    static func == (lhs: Landmark, rhs: Landmark) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
}

