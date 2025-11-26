//
//  PhotoGallery.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-10.
//

import SwiftUI

struct PhotoGallery: View {
    
    // Variables
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Binding var images: [UIImage]
    var onDelete: (UIImage) -> Void
    @State private var selectedImage: UIImage? = nil
    @State private var isEditing = false
    
    // View
    var body: some View {
        ZStack {
            Color(hex: "EAF6FF")
                .ignoresSafeArea()
            VStack {
                
                // Scrollable grid of uploaded images per landmark
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
                                
                                // Deleting an image is only possible when there is more than one image in the landmark gallery
                                if isEditing && images.count > 1 {
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
                
                // Image cannot be deleted when there is only one image in the landmark gallery
                if isEditing && images.count == 1 {
                    Text("You must keep at least one photo.")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(20)
                }
            }
            
            // Edit button for deleting images
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
        
        // Makes the image bigger when you click on it
        .fullScreenCover(isPresented: .constant(selectedImage != nil)) {
            if let img = selectedImage {
                ZStack {
                    Color(hex: "EAF6FF")
                        .ignoresSafeArea()
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                selectedImage = nil
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 32))
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                }
            }
        }

    }
}
