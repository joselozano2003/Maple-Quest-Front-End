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

    @State private var isUploadingImage = false
    @State private var uploadError: String?
    @State private var currentVisitId: Int?
    
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
                // Load local images first
                galleryImages = loadImages(for: landmark.name)
                
                // Then fetch from backend
                Task {
                    await loadImagesFromBackend()
                }
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
                    // Upload status indicator
                    if isUploadingImage {
                        HStack {
                            ProgressView()
                                .padding(.trailing, 8)
                            Text("Uploading photo to S3...")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Upload error
                    if let error = uploadError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
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
        // Add to local gallery immediately for UI feedback
        galleryImages.append(image)
        saveImages(galleryImages, for: landmark.name)
        onVisited(true)

        // Upload to S3 in the background
        Task {
            await uploadImageToS3(image)
        }

        showPhotoGallery = true
    }

    private func uploadImageToS3(_ image: UIImage) async {
        isUploadingImage = true
        uploadError = nil
        
        print("🚀 Starting S3 upload for landmark: \(landmark.name)")
        
        do {
            // First, upload the image to S3
            print("📤 Uploading image to S3...")
            let publicURL = try await ImageUploadService.shared.uploadImage(image)
            print("✅ Image uploaded to S3: \(publicURL)")
            
            // Get the backend location ID
            if currentVisitId == nil {
                print("📍 Fetching backend location ID...")
                
                let locations = try await APIService.shared.getLocations()
                guard let backendLocation = locations.first(where: { $0.name == landmark.name }) else {
                    throw ImageUploadError.uploadFailed("Location not found in backend")
                }
                
                print("📍 Creating/updating visit for location ID: \(backendLocation.location_id)")
                
                // Visit the location with the image
                // This will either create a new visit or add to existing visit
                let visitResponse = try await APIService.shared.visitLocation(
                    locationId: backendLocation.location_id,
                    note: "Visited \(landmark.name)",
                    images: [["image_url": publicURL, "description": "Photo at \(landmark.name)"]]
                )
                currentVisitId = visitResponse.visit.id
                print("✅ Visit ID: \(visitResponse.visit.id)")
                if let pointsEarned = visitResponse.points_earned {
                    print("✅ Points earned: \(pointsEarned)")
                } else {
                    print("✅ Image added to existing visit (no new points)")
                }
            } else {
                // We already have a visit, just add the image
                print("📍 Adding image to existing visit ID: \(currentVisitId!)")
                
                let locations = try await APIService.shared.getLocations()
                guard let backendLocation = locations.first(where: { $0.name == landmark.name }) else {
                    throw ImageUploadError.uploadFailed("Location not found in backend")
                }
                
                // Add image to existing visit
                let visitResponse = try await APIService.shared.visitLocation(
                    locationId: backendLocation.location_id,
                    images: [["image_url": publicURL, "description": "Photo at \(landmark.name)"]]
                )
                print("✅ Image added to existing visit")
            }
            
            // Save the image URL for future reference
            saveImageURL(publicURL, for: landmark.name)
            
        } catch {
            uploadError = error.localizedDescription
            print("❌ Failed to upload image: \(error)")
        }
        
        isUploadingImage = false
    }
    
    private func saveImageURL(_ url: String, for landmarkName: String) {
        var urls = loadImageURLs(for: landmarkName)
        urls.append(url)
        UserDefaults.standard.set(urls, forKey: "image_urls_\(landmarkName)")
    }
    
    private func loadImageURLs(for landmarkName: String) -> [String] {
        return UserDefaults.standard.stringArray(forKey: "image_urls_\(landmarkName)") ?? []
    }
    
    // This function now correctly receives a UIImage to delete
    private func deleteImage(_ image: UIImage) {
        galleryImages.removeAll { $0 == image }
        saveImages(galleryImages, for: landmark.name)
    }

    // MARK: - User Specific Storage
    
    func saveImages(_ images: [UIImage], for landmarkName: String) {
        guard let userId = authService.currentUser?.email else { return }
        let key = "photos_\(userId)_\(landmarkName)"
        
        let imageDataArray = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
        UserDefaults.standard.set(imageDataArray, forKey: "photos_\(landmarkName)")
    }

    func loadImages(for landmarkName: String) -> [UIImage] {
        guard let userId = authService.currentUser?.email else { return [] }
        let key = "photos_\(userId)_\(landmarkName)"
        
        guard let imageDataArray = UserDefaults.standard.array(forKey: key) as? [Data] else {
            return []
        }
        return imageDataArray.compactMap { UIImage(data: $0) }
    }

    private func loadImagesFromBackend() async {
        // Loading backend images is optional - don't show errors to user
        // Just log them for debugging
        
        print("📥 Loading images from backend for: \(landmark.name)")
        
        do {
            // Get backend location ID
            // Note: This endpoint should allow unauthenticated access
            print("🔍 Fetching locations from backend...")
            let locations = try await APIService.shared.getLocations()
            
            guard let backendLocation = locations.first(where: { $0.name == landmark.name }) else {
                print("⚠️ Location '\(landmark.name)' not found in backend")
                print("   Available locations: \(locations.map { $0.name }.joined(separator: ", "))")
                return
            }
            
            print("✅ Found backend location ID: \(backendLocation.location_id)")
            
            // Fetch images for this location
            print("🔍 Fetching images for location...")
            let locationImages = try await APIService.shared.getLocationImages(
                locationId: backendLocation.location_id
            )
            
            print("📥 Found \(locationImages.images.count) images from backend")
            
            if locationImages.images.isEmpty {
                print("   No images to download")
                return
            }
            
            // Download and add images that aren't already in the gallery
            for imageResponse in locationImages.images {

                var imageURL = imageResponse.image_url
                
                guard let url = URL(string: imageURL) else {
                    print("⚠️ Invalid image URL: \(imageURL)")
                    continue
                }
                
                // Check if we already have this image URL
                let existingURLs = loadImageURLs(for: landmark.name)
                if existingURLs.contains(imageResponse.image_url) {
                    print("⏭️ Skipping already downloaded image")
                    continue
                }
                
                print("⬇️ Downloading image from: \(imageURL)")
                
                // Download the image with timeout
                do {
                    let (data, response) = try await URLSession.shared.data(from: url)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        print("⚠️ Failed to download image - HTTP \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                        continue
                    }
                    
                    guard let image = UIImage(data: data) else {
                        print("⚠️ Failed to decode image data")
                        continue
                    }
                    
                    // Add to gallery if not already there
                    await MainActor.run {
                        galleryImages.append(image)
                    }
                    saveImageURL(imageResponse.image_url, for: landmark.name)
                    print("✅ Downloaded and added image to gallery")
                    
                } catch {
                    print("⚠️ Failed to download image: \(error.localizedDescription)")
                }
            }
            
        } catch APIError.httpError(let code, let message) {
            print("❌ HTTP Error \(code) loading images: \(message ?? "Unknown error")")
            if code == 401 {
                print("   Note: This might be an authentication issue, but backend images are optional")
            }
        } catch {
            print("❌ Failed to load images from backend: \(error)")
        }
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
