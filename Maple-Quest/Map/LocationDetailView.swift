//
//  LocationDetailView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-07.
//

import SwiftUI
import PhotosUI

struct LocationDetailView: View {
    
    var landmark: Landmark
    @State private var isPhotoUploaded: Bool = false
    @State private var selectedCameraOption: String?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showPhotoPicker: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geometry in
                    // Image Section
                    Image(landmark.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 500)
                        .frame(maxWidth: geometry.size.width)
                        .clipped()
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                }
                .frame(height: 500)
                .padding(.bottom, 20) // Padding between the image and info sections
            }
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
        .ignoresSafeArea(edges: .top)
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isPhotoUploaded {
                    Image(systemName: "checkmark.circle.fill")
                } else {
                    Menu {
                        Button {
                            selectedCameraOption = "Take Photo"
                        } label: {
                            Label("Take Photo", systemImage: "camera.fill")
                                .tint(.white)
                        }
                        Button {
                            selectedCameraOption = "Choose Photo"
                            showPhotoPicker = true
                        } label: {
                            Label("Choose Photo", systemImage: "photo.on.rectangle")
                                .tint(.white)
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photosPickerItem, matching: .images)
        .onChange(of: photosPickerItem) { _, newItem in
                Task {
                    if let newItem {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data) {
                                // Upload to a gallery in app
                                isPhotoUploaded = true
                            }
                        }
                        photosPickerItem = nil
                    }
                }
            }
    }
}


#Preview {
    ContentView()
}
