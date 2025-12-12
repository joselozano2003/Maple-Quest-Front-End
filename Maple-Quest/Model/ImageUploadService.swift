//
//  ImageUploadService.swift
//  Maple-Quest
//
//  Image upload service for AWS S3 integration using presigned URLs
//

import Foundation
import UIKit

enum ImageUploadError: LocalizedError {
    case compressionFailed
    case uploadFailed(String)
    case invalidImageData
    
    var errorDescription: String? {
        switch self {
        case .compressionFailed:
            return "Failed to compress image"
        case .uploadFailed(let message):
            return "Upload failed: \(message)"
        case .invalidImageData:
            return "Invalid image data"
        }
    }
}

class ImageUploadService {
    static let shared = ImageUploadService()
    private let apiService = APIService.shared
    
    private init() {}
    
    /// Uploads an image to S3 and returns the public URL
    /// - Parameters:
    ///   - image: The UIImage to upload
    ///   - compressionQuality: JPEG compression quality (0.0 to 1.0, default 0.8)
    ///   - progressHandler: Optional closure to track upload progress (0.0 to 1.0)
    /// - Returns: The public URL of the uploaded image
    func uploadImage(
        _ image: UIImage,
        compressionQuality: CGFloat = 0.8,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> String {
        
        // Step 1: Compress image to JPEG data
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            throw ImageUploadError.compressionFailed
        }
        
        // Step 2: Generate unique filename
        let filename = "image_\(UUID().uuidString).jpg"
        
        // Step 3: Get presigned upload URL from backend
        let uploadResponse = try await apiService.generateUploadURL(filename: filename)
        
        // Step 4: Upload image data to S3 using presigned URL
        try await uploadToS3WithPresignedURL(
            imageData: imageData,
            presignedURL: uploadResponse.upload_url,
            progressHandler: progressHandler
        )
        
        // Step 5: Return the public URL
        return uploadResponse.public_url
    }
    
    /// Uploads an image and creates an image record associated with a visit
    /// - Parameters:
    ///   - image: The UIImage to upload
    ///   - visitId: The visit ID to associate the image with
    ///   - description: Optional description for the image
    ///   - compressionQuality: JPEG compression quality (0.0 to 1.0, default 0.8)
    ///   - progressHandler: Optional closure to track upload progress (0.0 to 1.0)
    /// - Returns: The created ImageResponse
    func uploadImageForVisit(
        _ image: UIImage,
        visitId: Int,
        description: String = "",
        compressionQuality: CGFloat = 0.8,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> ImageResponse {
        
        // Upload image to S3
        let publicURL = try await uploadImage(
            image,
            compressionQuality: compressionQuality,
            progressHandler: progressHandler
        )
        
        // Create image record in backend
        let imageResponse = try await apiService.createImage(
            visitId: visitId,
            imageUrl: publicURL,
            description: description
        )
        
        return imageResponse
    }
    
    /// Uploads multiple images for a visit
    /// - Parameters:
    ///   - images: Array of UIImages to upload
    ///   - visitId: The visit ID to associate the images with
    ///   - compressionQuality: JPEG compression quality (0.0 to 1.0, default 0.8)
    ///   - progressHandler: Optional closure to track overall progress (0.0 to 1.0)
    /// - Returns: Array of created ImageResponse objects
    func uploadImagesForVisit(
        _ images: [UIImage],
        visitId: Int,
        compressionQuality: CGFloat = 0.8,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> [ImageResponse] {
        
        var uploadedImages: [ImageResponse] = []
        let totalImages = Double(images.count)
        
        for (index, image) in images.enumerated() {
            let imageResponse = try await uploadImageForVisit(
                image,
                visitId: visitId,
                compressionQuality: compressionQuality,
                progressHandler: { imageProgress in
                    // Calculate overall progress
                    let overallProgress = (Double(index) + imageProgress) / totalImages
                    progressHandler?(overallProgress)
                }
            )
            uploadedImages.append(imageResponse)
        }
        
        return uploadedImages
    }
    
    /// Uploads profile picture and returns the public URL
    /// - Parameters:
    ///   - image: The UIImage to upload as profile picture
    ///   - compressionQuality: JPEG compression quality (0.0 to 1.0, default 0.8)
    ///   - progressHandler: Optional closure to track upload progress (0.0 to 1.0)
    /// - Returns: The public URL of the uploaded profile picture
    func uploadProfilePicture(
        _ image: UIImage,
        compressionQuality: CGFloat = 0.8,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> String {
        
        // Resize image to reasonable profile picture size (e.g., 512x512)
        let resizedImage = image.resized(to: CGSize(width: 512, height: 512))
        
        return try await uploadImage(
            resizedImage,
            compressionQuality: compressionQuality,
            progressHandler: progressHandler
        )
    }
    
    // Private Methods
    
    /// Upload to S3 using presigned URL
    /// No AWS credentials needed - backend provides authenticated URL
    private func uploadToS3WithPresignedURL(
        imageData: Data,
        presignedURL: String,
        progressHandler: ((Double) -> Void)?
    ) async throws {
        
        guard let url = URL(string: presignedURL) else {
            throw ImageUploadError.uploadFailed("Invalid presigned URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        // Create URLSession with delegate for progress tracking
        let session = URLSession.shared
        
        do {
            let (_, response) = try await session.upload(for: request, from: imageData)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ImageUploadError.uploadFailed("Invalid response")
            }
            
            guard httpResponse.statusCode == 200 else {
                throw ImageUploadError.uploadFailed("HTTP \(httpResponse.statusCode)")
            }
            
            // Upload successful
            progressHandler?(1.0)
            
        } catch {
            throw ImageUploadError.uploadFailed(error.localizedDescription)
        }
    }
}

// UIImage Extension for Resizing

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determine the scale factor that preserves aspect ratio
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        return scaledImage
    }
}
