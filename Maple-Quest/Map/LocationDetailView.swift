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
    let userLocation: CLLocationCoordinate2D?
    var onVisited: (Bool) -> Void
    
    // Access AuthService to get the current user's email for saving photos securely
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
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
    
    // Main body of the view
    var body: some View {
        locationDetailContent
            .ignoresSafeArea(edges: .top)
            .toolbar {
                toolbarContent
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(image: $selectedImage)
                    .ignoresSafeArea(edges: .all)
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
                // Calls the PhotoGallery with the onDelete closure
                PhotoGallery(images: $galleryImages) { imageToDelete in
                    deleteImage(imageToDelete)
                }
                .navigationTitle("Gallery")
            }
            .onAppear {
                galleryImages = loadImages(for: landmark.name)
            }
    }
    
    // Landmark Detail Content
    private var locationDetailContent: some View {
        ZStack {
            Color(hex: "EAF6FF")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    ZStack {
                        GeometryReader { geometry in
                            // Image Section
                            Image("polaroid")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 450)
                                .frame(maxWidth: geometry.size.width)
                                .clipped()
                                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                            
                            Image(landmark.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 308, height: 312)
                                .clipped()
                                .offset(x: 48, y: 35)
                            
                            VStack {
                                // Title
                                Text(landmark.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black.opacity(0.8))
                                    .padding(.top, 65)
                                    .offset(y: 300)
                                
                                // Location
                                Text("\(landmark.province), \(landmark.country)")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .offset(y: 305)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .frame(height: 450)
                    .padding(.top, 120) // Padding between the top bar and the polaroid
                }
                // Info Section
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
                    Text("Details")
                        .font(.title2).bold()
                    // Description
                    Text(landmark.description)
                        .font(.system(size: 17))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.top, 5)
                    Divider()
                    // Proximity Check
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
                }
                .padding()
            }
        }
    }
    
    // Toolbar Content
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
            .disabled(!isUserNearby) // This feature is disabled if the user is not nearby
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
    
    private func deleteImage(_ image: UIImage) {
        galleryImages.removeAll { $0 == image }
        saveImages(galleryImages, for: landmark.name)
    }

    // MARK: - User Specific Storage
    
    func saveImages(_ images: [UIImage], for landmarkName: String) {
        guard let userId = authService.currentUser?.email else { return }
        let key = "photos_\(userId)_\(landmarkName)"
        
        let imageDataArray = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
        UserDefaults.standard.set(imageDataArray, forKey: key)
    }

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
