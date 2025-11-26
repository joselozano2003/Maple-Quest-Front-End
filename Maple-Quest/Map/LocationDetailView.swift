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
    
    // Variables
    var landmark: Landmark
    let userLocation: CLLocationCoordinate2D?
    var onVisited: (Bool) -> Void
    @State private var galleryImages: [UIImage] = []
    @State private var selectedCameraOption: String?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showPhotoPicker: Bool = false
    @State private var showPhotoGallery: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showCamera: Bool = false
    private var visitedLandmark: Bool {
        !galleryImages.isEmpty
    }
    
    // Access AuthService to get the current user's email for saving photos securely
    @EnvironmentObject var authService: AuthService
    
    // Calculates the user's distance from the landmark in meters
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
    
    // View
    var body: some View {
        
        // Landmark photo, name, location and description
        locationDetailContent
            .ignoresSafeArea(edges: .top)
            .toolbar {
                
                // Buttons for photo uploads and landmark gallery
                toolbarContent
            }
        
            // Shows camera when selecting 'Take Photo'
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(image: $selectedImage)
                    .ignoresSafeArea(edges: .all)
            }
        
            // Handles photo upload when taking a photo
            .onChange(of: selectedImage) { _, newItem in
                if let newItem {
                    handlePhotoUpload(image: newItem)
                }
            }
        
        
            // Shows photo library when selecting 'Choose Photo'
            .photosPicker(isPresented: $showPhotoPicker, selection: $photosPickerItem, matching: .images)
            
            // Handles photo upload when choosing a photo
            .onChange(of: photosPickerItem) { _, newItem in
                Task {
                    if let newItem, let data = try? await newItem.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                        handlePhotoUpload(image: image)
                    }
                    photosPickerItem = nil
                }
            }
        
            .navigationDestination(isPresented: $showPhotoGallery) {
                
                // Calls the PhotoGallery with the onDelete closure
                PhotoGallery(images: $galleryImages) { imageToDelete in
                    deleteImage(imageToDelete)
                }
                .navigationTitle("Gallery")
            }
        
            // Displays images uploaded in the gallery to each landmark
            .onAppear {
                galleryImages = loadImages(for: landmark.name)
            }
    }
    
    // Landmark detail content view
    private var locationDetailContent: some View {
        ZStack {
            Color(hex: "EAF6FF")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    ZStack {
                        GeometryReader { geometry in
                            
                            // Polaroid template
                            Image("polaroid")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 450)
                                .frame(maxWidth: geometry.size.width)
                                .clipped()
                                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                            
                            // Landmark image
                            Image(landmark.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 308, height: 312)
                                .clipped()
                                .offset(x: 48, y: 35)
                            
                            VStack {
                                
                                // Landmark name
                                Text(landmark.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black.opacity(0.8))
                                    .padding(.top, 65)
                                    .offset(y: 300)
                                
                                // Landmark location
                                Text("\(landmark.province), \(landmark.country)")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .offset(y: 305)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .frame(height: 450)
                    
                    // Padding between the top bar and the polaroid
                    .padding(.top, 120)
                }
                
                // Displays text indicating whether or not the user has visited that landmark before
                VStack(alignment: .leading) {
                    if visitedLandmark {
                        Text("You have visited this landmark before!")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("You have not visited this landmark before!")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.top, -20)
                    }
                    
                    Divider()
                        .padding(5)
                    
                    // Landmark description
                    Text("Details")
                        .font(.title2).bold()
                        .foregroundColor(.black)
                    Text(landmark.description)
                        .font(.system(size: 17))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.top, 5)
                    
                    Divider()
                    
                    // Checks how close the user is to the landmark
                    if let distance = distanceFromLandmark {
                        HStack {
                            Image(systemName: isUserNearby ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isUserNearby ? .green : .red)
                            Text(isUserNearby ? "You are here! You can add photos." : "You are \(String(format: "%.2f", distance / 1000)) km away. Get closer to add photos.")
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.6))
                        }
                    } else {
                        HStack {
                            Image(systemName: "location.slash.fill")
                            Text("Searching for your location...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    // Toolbar content
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
        // Menu to upload an image to the landmark gallery
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
            
            // The feature to upload a photo at a landmark is disabled if the user is not within 500 meters.
            .disabled(!isUserNearby)
        }
        
        // Button to view the landmark gallery
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showPhotoGallery = true
            } label: {
                Image(systemName: "square.grid.2x2")
            }
        }
    }
    
    // Function that handles uploading a photo and adds it to the landmark gallery
    private func handlePhotoUpload(image: UIImage) {
        galleryImages.append(image)
        saveImages(galleryImages, for: landmark.name)
        onVisited(true)
        showPhotoGallery = true
    }
    
    // Function that deletes an image from the gallery
    private func deleteImage(_ image: UIImage) {
        galleryImages.removeAll { $0 == image }
        saveImages(galleryImages, for: landmark.name)
    }

    // Function that saves the images uploaded by the user in each landmark so it persists between app launches
    func saveImages(_ images: [UIImage], for landmarkName: String) {
        guard let userId = authService.currentUser?.email else { return }
        let key = "photos_\(userId)_\(landmarkName)"
        let imageDataArray = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
        UserDefaults.standard.set(imageDataArray, forKey: key)
    }

    // Function that retrieves saved images in each landmark and displays them in the gallery
    func loadImages(for landmarkName: String) -> [UIImage] {
        guard let userId = authService.currentUser?.email else { return [] }
        let key = "photos_\(userId)_\(landmarkName)"
        guard let imageDataArray = UserDefaults.standard.array(forKey: key) as? [Data] else {
            return []
        }
        return imageDataArray.compactMap { UIImage(data: $0) }
    }
}

#Preview {
    // Preview needs a mock environment
    NavigationStack {
        LocationDetailView(
            landmark: landmarks[0],
            userLocation: CLLocationCoordinate2D(latitude: 43.0946853, longitude: -79.039969),
            onVisited: { _ in }
        )
        .environmentObject(AuthService.shared)
        .environmentObject(LocationManager())
    }
}
