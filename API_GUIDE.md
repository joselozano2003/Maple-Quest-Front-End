# iOS API Integration Guide

This guide shows how to make API requests to the Django backend from the iOS app.

## Configuration

### 1. Set Backend URL

Update the backend URL in `Model/APIConfig.swift`:

```swift
struct APIConfig {
    static let baseURL = "http://localhost:8000"  // Local development
    // static let baseURL = "https://your-api.com"  // Production
}
```

## Authentication

### Getting the Access Token

The `AuthService` automatically manages JWT tokens. Access the current token:

```swift
let authService = AuthService.shared
let accessToken = KeychainService().getAccessToken()
```

## Making API Requests

### Basic GET Request (No Auth)

```swift
func getLocations() async throws -> [Location] {
    let url = URL(string: "\(APIConfig.baseURL)/api/locations/")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode([Location].self, from: data)
}
```

### GET Request with Authentication

```swift
func getMyVisits() async throws -> [Visit] {
    guard let token = KeychainService().getAccessToken() else {
        throw APIError.unauthorized
    }

    let url = URL(string: "\(APIConfig.baseURL)/api/visits/")!
    var request = URLRequest(url: url)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode([Visit].self, from: data)
}
```

### POST Request with Authentication

```swift
func visitLocation(locationId: String, note: String) async throws {
    guard let token = KeychainService().getAccessToken() else {
        throw APIError.unauthorized
    }

    let url = URL(string: "\(APIConfig.baseURL)/api/locations/\(locationId)/visit/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = ["note": note]
    request.httpBody = try JSONEncoder().encode(body)

    let (_, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw APIError.requestFailed
    }
}
```

### PUT Request (Update Profile)

```swift
func updateProfile(firstName: String, lastName: String) async throws {
    guard let token = KeychainService().getAccessToken() else {
        throw APIError.unauthorized
    }

    let url = URL(string: "\(APIConfig.baseURL)/auth/profile/")!
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = [
        "first_name": firstName,
        "last_name": lastName
    ]
    request.httpBody = try JSONEncoder().encode(body)

    let (data, _) = try await URLSession.shared.data(for: request)
    let user = try JSONDecoder().decode(APIUser.self, from: data)
}
```

## Common API Endpoints

### Authentication Endpoints

#### Login

```swift
// POST /auth/login/
let body = [
    "email": "user@example.com",
    "password": "password123"
]
// Returns: { user: {...}, tokens: {...}, message: "..." }
```

#### Register

```swift
// POST /auth/register/
let body = [
    "email": "user@example.com",
    "password": "password123",
    "first_name": "John",      // Optional
    "last_name": "Doe",         // Optional
    "phone_no": "1234567890"    // Optional
]
// Returns: { user: {...}, tokens: {...}, message: "..." }
```

#### Get Profile

```swift
// GET /auth/profile/
// Headers: Authorization: Bearer <token>
// Returns: { user_id, email, first_name, last_name, ... }
```

#### Update Profile

```swift
// PUT /auth/profile/
// Headers: Authorization: Bearer <token>
let body = [
    "first_name": "Johnny",
    "last_name": "Smith",
    "phone_no": "9876543210"
]
// Returns: Updated user object
```

### Location Endpoints

#### Get All Locations

```swift
// GET /api/locations/
// No authentication required
// Returns: Array of location objects
```

#### Visit Location

```swift
// POST /api/locations/{location_id}/visit/
// Headers: Authorization: Bearer <token>
let body = [
    "note": "Amazing place!",
    "images": [
        [
            "image_url": "https://...",
            "description": "Beautiful view"
        ]
    ]
]
// Returns: { message, visit, images, points_earned, total_points }
```

#### Get Location Images

```swift
// GET /api/locations/{location_id}/images/
// No authentication required
// Returns: { location_id, location_name, total_images, images: [...] }
```

### Visit Endpoints

#### Get My Visits

```swift
// GET /api/visits/
// Headers: Authorization: Bearer <token>
// Returns: Array of visit objects with images
```

### Friend Endpoints

#### Add Friend

```swift
// POST /api/friend-requests/add_friend/
// Headers: Authorization: Bearer <token>
let body = ["email": "friend@example.com"]
// OR
let body = ["phone_no": "1234567890"]
// Returns: { message, friend_request }
```

#### Get Friends List

```swift
// GET /api/users/friends/
// Headers: Authorization: Bearer <token>
// Returns: { friends: [...], count: N }
```

#### Accept Friend Request

```swift
// POST /api/friend-requests/{request_id}/accept/
// Headers: Authorization: Bearer <token>
// Returns: { status: "accepted" }
```

## Complete Example: API Service Class

```swift
import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = APIConfig.baseURL
    private let keychain = KeychainService()

    // MARK: - Generic Request Method
    private func performRequest<T: Codable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {

        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add auth token if required
        if requiresAuth {
            guard let token = keychain.getAccessToken() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Add body if provided
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Example Usage
    func getLocations() async throws -> [Location] {
        return try await performRequest(
            endpoint: "/api/locations/",
            requiresAuth: false
        )
    }

    func visitLocation(locationId: String, note: String) async throws -> VisitResponse {
        return try await performRequest(
            endpoint: "/api/locations/\(locationId)/visit/",
            method: "POST",
            body: ["note": note]
        )
    }

    func getFriends() async throws -> FriendsResponse {
        return try await performRequest(
            endpoint: "/api/users/friends/"
        )
    }
}

// MARK: - Error Types
enum APIError: LocalizedError {
    case invalidURL
    case unauthorized
    case invalidResponse
    case httpError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unauthorized:
            return "Not authenticated"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        }
    }
}
```

## Usage in SwiftUI Views

```swift
struct LocationsView: View {
    @State private var locations: [Location] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        List(locations) { location in
            Text(location.name)
        }
        .onAppear {
            Task {
                await loadLocations()
            }
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

## Token Refresh

The `AuthService` automatically handles token refresh. If a request returns 401:

```swift
// In AuthService.swift
if httpResponse.statusCode == 401 {
    // Try to refresh token
    if await refreshToken() {
        // Retry the request with new token
        // ... retry logic
    }
    throw AuthError.unauthorized
}
```

## Image Upload

### Step 1: Get Upload URL

```swift
func getUploadURL(filename: String) async throws -> UploadURLResponse {
    guard let token = keychain.getAccessToken() else {
        throw APIError.unauthorized
    }

    let url = URL(string: "\(baseURL)/api/users/generate_upload_url/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = ["filename": filename]
    request.httpBody = try JSONEncoder().encode(body)

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(UploadURLResponse.self, from: data)
}
```

### Step 2: Upload Image

```swift
func uploadImage(imageData: Data, to uploadURL: String) async throws {
    guard let url = URL(string: uploadURL) else {
        throw APIError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
    request.httpBody = imageData

    let (_, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw APIError.uploadFailed
    }
}
```

### Step 3: Use Public URL

```swift
// After upload, use the public_url in your visit
let visitBody = [
    "note": "Beautiful place!",
    "images": [
        [
            "image_url": uploadResponse.public_url,
            "description": "Amazing view"
        ]
    ]
]
```

## Testing API Calls

### Using Xcode Playground

```swift
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

Task {
    do {
        let locations = try await APIService.shared.getLocations()
        print("Locations: \(locations)")
    } catch {
        print("Error: \(error)")
    }
}
```

### Using Print Debugging

```swift
func debugRequest(_ request: URLRequest) {
    print("🌐 \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
    if let headers = request.allHTTPHeaderFields {
        print("📋 Headers: \(headers)")
    }
    if let body = request.httpBody,
       let bodyString = String(data: body, encoding: .utf8) {
        print("📦 Body: \(bodyString)")
    }
}
```

## Common Issues

### Issue: 401 Unauthorized

**Solution**: Check if token is valid and not expired

```swift
if let token = keychain.getAccessToken() {
    print("Token exists: \(token.prefix(20))...")
} else {
    print("No token found - user needs to login")
}
```

### Issue: CORS Error (in simulator)

**Solution**: Make sure backend allows requests from localhost

```python
# In Django settings.py
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8000",
]
```

### Issue: Connection Refused

**Solution**: Use correct URL for simulator

- iOS Simulator: `http://localhost:8000`
- Physical Device: `http://YOUR_COMPUTER_IP:8000`

## Best Practices

1. **Always handle errors gracefully**

```swift
do {
    let data = try await apiCall()
} catch APIError.unauthorized {
    // Redirect to login
} catch {
    // Show error message
}
```

2. **Show loading states**

```swift
@State private var isLoading = false

Button("Load Data") {
    Task {
        isLoading = true
        await loadData()
        isLoading = false
    }
}
```

3. **Cache data when appropriate**

```swift
@AppStorage("cachedLocations") private var cachedData: Data?
```

4. **Use proper error messages**

```swift
@State private var errorMessage: String?

if let error = errorMessage {
    Text(error)
        .foregroundColor(.red)
}
```
