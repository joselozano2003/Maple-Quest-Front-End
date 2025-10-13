//
//  MapPreview.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-13.
//

import SwiftUI
import MapKit

struct MapPreview: View {
    
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
