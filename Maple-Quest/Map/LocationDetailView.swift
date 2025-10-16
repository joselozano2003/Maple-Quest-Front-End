//
//  LocationDetailView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-07.
//

import SwiftUI
import PhotosUI
import CoreLocation

struct LocationDetailView: View {
    
    var landmark: Landmark
    // Receive the user's location from the MapView
    let userLocation: CLLocationCoordinate2D?
    var onVisited: (Bool) -> Void
    
    @State private var galleryImages: [UIImage] = []
    @State private var selectedCameraOption: String?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showPhotoPicker: Bool = false
    @State private var showPhotoGallery: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showCamera: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    // Calculate the distance from the landmark in meters
    private var distanceFromLandmark: CLLocationDistance? {
        guard let userLocation = userLocation else { return nil }
        let landmarkLocationCL = CLLocation(latitude: landmark.location.latitude, longitude: landmark.location.longitude)
        let userLocationCL = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        return userLocationCL.distance(from: landmarkLocationCL)
    }
    
    // Check if the user is within 500 meters of the landmark
    private var isUserNearby: Bool {
        guard let distance = distanceFromLandmark else { return false }
        return distance <= 500 // 500 meters is the required proximity
    }
    
    // Main body of the view, simplified to improve compile times
    var body: some View {
        mainContent
            .ignoresSafeArea(edges: .top)
            .toolbar {
                toolbarContent
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(image: $selectedImage)
            }
            .onChange(of: selectedImage) { _, newItem in
                if let newItem {
                    handlePhotoUpload(image: newItem)
                }
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $photosPickerItem, matching: .images)
            .onChange(of: photosPickerItem) { _, newItem in
                Task {
                    if let newItem, let data = try? await newItem.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                        handlePhotoUpload(image: image)
                    }
                    photosPickerItem = nil
                }
            }
            .navigationDestination(isPresented: $showPhotoGallery) {
                // This now correctly calls the updated PhotoGallery with the onDelete closure
                PhotoGallery(images: $galleryImages) { imageToDelete in
                    deleteImage(imageToDelete)
                }
                .navigationTitle("Gallery")
            }
            .onAppear {
                galleryImages = loadImages(for: landmark.name)
            }
    }
    
    // Extracted view for the main scrollable content
    private var mainContent: some View {
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
            VStack(alignment: .leading, spacing: 12) {
                Text(landmark.name)
                    .font(.largeTitle).bold()
                
                Text("\(landmark.province), \(landmark.country)")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Divider()
                
                // Proximity Check Section
                if let distance = distanceFromLandmark {
                    HStack {
                        Image(systemName: isUserNearby ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isUserNearby ? .green : .red)
                        Text(isUserNearby ? "You are here! You can add photos." : "You are \(String(format: "%.2f", distance / 1000)) km away. Get closer to add photos.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    HStack {
                        Image(systemName: "location.slash.fill")
                        Text("Searching for your location...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Divider()
                
                // Description
                Text(landmark.description)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
            .padding()
        }
    }
    
    // Extracted builder for the toolbar content
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button {
                    selectedCameraOption = "Take Photo"
                    showCamera = true
                } label: {
                    Label("Take Photo", systemImage: "camera.fill")
                }
                Button {
                    selectedCameraOption = "Choose Photo"
                    showPhotoPicker = true
                } label: {
                    Label("Choose Photo", systemImage: "photo.on.rectangle")
                }
            } label: {
                Image(systemName: "plus.circle.fill")
            }
            .disabled(!isUserNearby)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showPhotoGallery = true
            } label: {
                Image(systemName: "square.grid.2x2")
            }
        }
    }
    
    private func handlePhotoUpload(image: UIImage) {
        galleryImages.append(image)
        saveImages(galleryImages, for: landmark.name)
        onVisited(true)
        showPhotoGallery = true
    }
    
    // This function now correctly receives a UIImage to delete
    private func deleteImage(_ image: UIImage) {
        galleryImages.removeAll { $0 == image }
        saveImages(galleryImages, for: landmark.name)
    }

    func saveImages(_ images: [UIImage], for landmarkName: String) {
        let imageDataArray = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
        UserDefaults.standard.set(imageDataArray, forKey: "photos_\(landmarkName)")
    }

    func loadImages(for landmarkName: String) -> [UIImage] {
        guard let imageDataArray = UserDefaults.standard.array(forKey: "photos_\(landmarkName)") as? [Data] else {
            return []
        }
        return imageDataArray.compactMap { UIImage(data: $0) }
    }
}

#Preview {
    ContentView()
}


