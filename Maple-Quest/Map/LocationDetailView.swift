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
        
        VStack {
            // Image of the landmark
            Image(landmark.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipped()
                .ignoresSafeArea(edges: .top)
            }
        
        
        VStack {
            VStack(alignment: .leading) {
                // Landmark title
                Text(landmark.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                    .padding(.leading)
                // Landmark location (i.e. city, province and country)
                Text("\(landmark.province), \(landmark.country)")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .padding(.leading)
                Divider()
                // Description of landmark
                Text(landmark.description)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
            Spacer()
        }
        
    }
}
