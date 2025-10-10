//
//  ImageGallery.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-10.
//

import SwiftUI

struct PhotoGallery: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Binding var images: [UIImage]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .clipped()
                }
            }
            .padding()
        }
    }
}
