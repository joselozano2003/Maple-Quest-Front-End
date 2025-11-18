//
//  PhotoGallery.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-10.
//

import SwiftUI

struct PhotoGallery: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Binding var images: [UIImage]
    // This closure will be called when the user taps the delete button on an image
    var onDelete: (UIImage) -> Void
    @State private var selectedImage: UIImage? = nil
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(images, id: \.self) { image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .clipped()
                                .onTapGesture {
                                    selectedImage = image
                                }
                            
                            if isEditing {
                                Button(action: {
                                    onDelete(image)
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Circle().fill(Color.white))
                                        .font(.title2)
                                        .padding(4)
                                }
                                .transition(.scale)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation {
                        isEditing.toggle()
                    }
                }
            }
        }
    }
}
