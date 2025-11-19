# API Service Usage Guide

## Overview

The `APIService` class provides a complete, type-safe interface to interact with the Maple Quest Django backend API. It handles authentication, error handling, and provides convenient methods for all API endpoints.

## Architecture

- **APIService**: Main service for all API calls (locations, visits, images, friends, achievements)
- **AuthService**: Handles authentication (login, register, profile, token refresh)
- **KeychainService**: Secure token and user data storage
- **APIConfig**: Base URL configuration

## Quick Start

```swift
// The service is a singleton
let api = APIService.shared

// All methods are async and throw errors
Task {
    do {
        let locations = try await api.getLocations()
        print("Found \(locations.count) locations")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

## Authentication

Authentication is handled automatically by `AuthService`. Once logged in, all API calls include the JWT token.

```swift
// Login
await AuthService.shared.login(email: "user@example.com", password: "password")

// Register
await AuthService.shared.register(
    email: "new@example.com",
    password: "password",
    firstName: "John",
    lastName: "Doe",
    phoneNumber: "1234567890"
)

// Logout
AuthService.shared.logout()
```

## API Methods

### Locations

#### Get All Locations

```swift
let locations = try await api.getLocations()
// Returns: [LocationResponse]
```

#### Get Specific Location

```swift
let location = try await api.getLocation(id: "loc123")
// Returns: LocationResponse
```

#### Visit a Location

```swift
// Simple visit
let result = try await api.visitLocation(locationId: "loc123")

// Visit with note
let result = try await api.visitLocation(
    locationId: "loc123",
    note: "Beautiful place!"
)

// Visit with images
let result = try await api.visitLocation(
    locationId: "loc123",
    note: "Amazing views",
    images: [
        ["image_url": "https://...", "description": "Sunset view"],
        ["image_url": "https://...", "description": "Mountain peak"]
    ]
)
// Returns: LocationVisitResponse (includes points earned)
```

#### Get Location Images

```swift
let images = try await api.getLocationImages(locationId: "loc123")
// Returns: LocationImagesResponse
```

### Visits

#### Get User's Visit History

```swift
let visits = try await api.getVisits()
// Returns: [VisitResponse]
```

### Images

#### Upload Image Flow

```swift
// 1. Get presigned URL
let uploadInfo = try await api.generateUploadURL(filename: "photo.jpg")

// 2. Upload image data to S3
let imageData = image.jpegData(compressionQuality: 0.8)!
try await api.uploadImageToS3(imageData: imageData, presignedURL: uploadInfo.upload_url)

// 3. Use uploadInfo.public_url when visiting a location
let result = try await api.visitLocation(
    locationId: "loc123",
    images: [["image_url": uploadInfo.public_url, "description": "My photo"]]
)
```

#### Get User's Images

```swift
let images = try await api.getImages()
// Returns: [ImageResponse]
```

#### Create Image Record

```swift
let image = try await api.createImage(
    visitId: 42,
    imageUrl: "https://...",
    description: "Beautiful sunset"
)
// Returns: ImageResponse
```

### Friends

#### Get Friends List

```swift
let response = try await api.getFriends()
print("You have \(response.count) friends")
// Returns: FriendsResponse
```

#### Send Friend Request

```swift
// By email
let result = try await api.addFriend(email: "friend@example.com")

// By phone number
let result = try await api.addFriend(phoneNumber: "1234567890")
// Returns: FriendRequestResponse
```

#### Get Friend Requests

```swift
let requests = try await api.getFriendRequests()
// Returns: [FriendRequest] (pending, sent, received)
```

#### Accept Friend Request

```swift
let result = try await api.acceptFriendRequest(requestId: 123)
// Returns: ["status": "accepted"]
```

#### Reject Friend Request

```swift
let result = try await api.rejectFriendRequest(requestId: 123)
// Returns: ["status": "rejected"]
```

### Achievements

#### Get All Achievements

```swift
let achievements = try await api.getAchievements()
// Returns: [AchievementResponse]
```

## Error Handling

The API service uses a custom `APIError` enum for error handling:

```swift
enum APIError: LocalizedError {
    case invalidURL
    case unauthorized
    case invalidResponse
    case httpError(Int, String?)
    case requestFailed
    case decodingError(Error)
}
```

### Handling Errors

```swift
do {
    let locations = try await api.getLocations()
} catch APIError.unauthorized {
    // Token expired or invalid - redirect to login
    print("Please log in again")
} catch APIError.httpError(let code, let message) {
    // HTTP error from server
    print("Server error \(code): \(message ?? "Unknown")")
} catch APIError.decodingError(let error) {
    // Response format doesn't match expected model
    print("Data format error: \(error)")
} catch {
    // Other errors
    print("Unexpected error: \(error.localizedDescription)")
}
```

## Response Models

### LocationResponse

```swift
struct LocationResponse: Codable {
    let location_id: String
    let name: String
    let province: String?
    let latitude: String
    let longitude: String
    let description: String
    let points: Int
    let default_image_url: String?
}
```

### LocationVisitResponse

```swift
struct LocationVisitResponse: Codable {
    let message: String
    let visit: VisitResponse
    let images: [ImageResponse]?
    let points_earned: Int
    let total_points: Int
}
```

### ImageResponse

```swift
struct ImageResponse: Codable {
    let id: Int
    let visit: Int
    let image_url: String
    let description: String
    let likes: Int
}
```

### FriendsResponse

```swift
struct FriendsResponse: Codable {
    let friends: [Friend]
    let count: Int
}
```

## Best Practices

### 1. Use in SwiftUI Views

```swift
struct LocationsView: View {
    @State private var locations: [LocationResponse] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        List(locations, id: \.location_id) { location in
            Text(location.name)
        }
        .task {
            await loadLocations()
        }
    }

    func loadLocations() async {
        isLoading = true
        errorMessage = nil

        do {
            locations = try await APIService.shared.getLocations()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
```

### 2. Handle Authentication State

```swift
@StateObject private var authService = AuthService.shared

if authService.isAuthenticated {
    // Show main app
} else {
    // Show login screen
}
```

### 3. Automatic Token Refresh

The `AuthService` automatically handles token refresh when a 401 error occurs. You don't need to manually refresh tokens.

### 4. Image Upload Pattern

Always follow this pattern for uploading images:

1. Generate presigned URL
2. Upload to S3
3. Use public URL in API calls

## Common Use Cases

### Complete Location Visit with Photo

```swift
func visitLocationWithPhoto(locationId: String, image: UIImage, note: String) async throws {
    // 1. Compress image
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        throw APIError.requestFailed
    }

    // 2. Get upload URL
    let uploadInfo = try await APIService.shared.generateUploadURL(
        filename: "visit_\(UUID().uuidString).jpg"
    )

    // 3. Upload to S3
    try await APIService.shared.uploadImageToS3(
        imageData: imageData,
        presignedURL: uploadInfo.upload_url
    )

    // 4. Visit location with image
    let result = try await APIService.shared.visitLocation(
        locationId: locationId,
        note: note,
        images: [["image_url": uploadInfo.public_url, "description": note]]
    )

    print("Earned \(result.points_earned) points! Total: \(result.total_points)")
}
```

### Load User's Complete Profile

```swift
func loadUserProfile() async {
    do {
        // Get profile
        let success = await AuthService.shared.fetchProfile()

        // Get visits
        let visits = try await APIService.shared.getVisits()

        // Get friends
        let friends = try await APIService.shared.getFriends()

        // Get achievements
        let achievements = try await APIService.shared.getAchievements()

        // Update UI with all data
    } catch {
        print("Error loading profile: \(error)")
    }
}
```

## Testing

### Mock API Calls

For testing, you can create a protocol and mock implementation:

```swift
protocol APIServiceProtocol {
    func getLocations() async throws -> [LocationResponse]
    // ... other methods
}

extension APIService: APIServiceProtocol {}

class MockAPIService: APIServiceProtocol {
    func getLocations() async throws -> [LocationResponse] {
        return [
            LocationResponse(
                location_id: "test1",
                name: "Test Location",
                province: "ON",
                latitude: "43.6532",
                longitude: "-79.3832",
                description: "Test",
                points: 100,
                default_image_url: nil
            )
        ]
    }
}
```

## Troubleshooting

### "Not authenticated" Error

- Check if user is logged in: `AuthService.shared.isAuthenticated`
- Try logging in again
- Check if token is stored: `KeychainService().getAccessToken()`

### "Invalid response" Error

- Check network connectivity
- Verify API base URL in `APIConfig`
- Check backend server is running

### Decoding Errors

- Response format may have changed on backend
- Check response models match backend serializers
- Enable debug logging to see raw response

### HTTP 401 Errors

- Token may be expired (should auto-refresh)
- User may need to log in again
- Check backend authentication settings

## Additional Resources

- Backend API Documentation: `backend/ARCHITECTURE.md`
- Authentication Flow: `frontend/AUTHENTICATION.md`
- API Endpoints: `backend/core/urls.py`
- Data Models: `backend/core/models.py`
