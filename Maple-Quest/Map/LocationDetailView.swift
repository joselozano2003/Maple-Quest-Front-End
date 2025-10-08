//
//  LocationDetailView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-07.
//

import SwiftUI

struct LocationDetailView: View {
    
    var landmark: Landmark
    
    var body: some View {
        ScrollView {
            VStack {
                // Image Section
                Image(landmark.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .ignoresSafeArea(edges: .top)
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            }
            
            .frame(height: 375) // Frame height of the image
            .padding(.bottom, 110) // Padding between the image and info sections
            
            // Info Section
            VStack(alignment: .leading) {
                // Title
                Text(landmark.name)
                    .font(.title).bold()
                    .padding(.bottom, 2)
                    .padding(.leading)
                // Location
                Text("\(landmark.province), \(landmark.country)")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .padding(.leading)
                Divider()
                // Description
                Text(landmark.description)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                    .padding(.leading)
            }
        }
    }
}
