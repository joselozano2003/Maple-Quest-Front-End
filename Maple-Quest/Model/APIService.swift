import Foundation

// MARK: - API Response Models

// Friend-Related
struct FriendRequestResponse: Codable {
    let message: String
    let friend_request: FriendRequest
}

struct FriendsResponse: Codable {
    let friends: [Friend]
    let count: Int
}

struct FriendRequestsListResponse: Codable {
    let results: [FriendRequest]
    let count: Int
    let next: String?
    let previous: String?
}

// Location-Related
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

struct LocationsListResponse: Codable {
    let results: [LocationResponse]
    let count: Int?
}

struct VisitResponse: Codable {
    let id: Int
    let user: String
    let location: String
    let visited_at: String
    let note: String?
}

struct LocationVisitResponse: Codable {
    let message: String
    let visit: VisitResponse
    let images: [ImageResponse]?
    let images_added: [ImageResponse]?
    let points_earned: Int?
    let total_points: Int?
}

// Image-Related
struct ImageResponse: Codable {
    let id: Int
    let visit: Int
    let image_url: String
    let description: String
    let likes: Int
}

struct LocationImagesResponse: Codable {
    let location_id: String
    let location_name: String
    let total_images: Int
    let images: [ImageResponse]
}

struct UploadURLResponse: Codable {
    let upload_url: String
    let public_url: String
    let file_key: String
    let expires_in: Int
}

// Achievement-Related
struct AchievementResponse: Codable {
    let achievement_id: String
    let description: String
    let points: Int
}

struct AchievementsListResponse: Codable {
    let results: [AchievementResponse]
    let count: Int?
}

// -- NEW STRUCT FOR POINTS SYNC --
struct UpdatePointsResponse: Codable {
    let message: String
    let total_points: Int
}

// MARK: - Error Types

enum APIError: LocalizedError {
    case invalidURL
    case unauthorized
    case invalidResponse
    case httpError(Int, String?)
    case requestFailed
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unauthorized:
            return "Not authenticated"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code, let message):
            if let message = message {
                return "HTTP Error \(code): \(message)"
            }
            return "HTTP Error: \(code)"
        case .requestFailed:
            return "Request failed due to bad parameters"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

// MARK: - Main APIService Class

class APIService {
    static let shared = APIService()
    
    private let baseURL = APIConfig.baseURL
    private let keychain = KeychainService()
    
    private init() {}

    // MARK: - Generic Request Method
    private func performRequest<T: Codable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        queryParams: [String: String]? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        
        var urlString = baseURL + endpoint
        
        // Add query parameters if provided
        if let queryParams = queryParams, !queryParams.isEmpty {
            let queryString = queryParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            urlString += "?\(queryString)"
        }

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth {
            guard let token = keychain.getAccessToken() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Auth: Sending request WITH authentication to \(endpoint)")
        } else {
            print("Auth: Sending request WITHOUT authentication to \(endpoint)")
        }

        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            let errorMessage = String(data: data, encoding: .utf8)
            print("HTTP Error \(httpResponse.statusCode). Response: \(errorMessage ?? "No response body")")
            throw APIError.httpError(httpResponse.statusCode, errorMessage)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response data: \(jsonString)")
            }
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - NEW: Update Points
    
    /// Syncs the local point count to the backend (POST /api/users/update_points/)
    func updatePoints(points: Int) async throws {
        let body: [String: Any] = ["points": points]
        
        // We expect UpdatePointsResponse (or we can ignore the result if we just want it to work)
        let _: UpdatePointsResponse = try await performRequest(
            endpoint: "/api/users/update_points/",
            method: "POST",
            body: body
        )
        print("Points synced to server: \(points)")
    }

    // MARK: - Friend Endpoints

    /// Sends a friend request via email or phone number (POST /api/friend-requests/add_friend/)
    func addFriend(email: String? = nil, phoneNumber: String? = nil) async throws -> FriendRequestResponse {
        var body: [String: Any] = [:]
        if let email = email {
            body["email"] = email
        } else if let phoneNumber = phoneNumber {
            body["phone_no"] = phoneNumber
        } else {
            throw APIError.requestFailed
        }

        return try await performRequest(
            endpoint: "/api/friend-requests/add_friend/",
            method: "POST",
            body: body
        )
    }

    /// Gets the current user's friends list (GET /api/users/friends/)
    func getFriends() async throws -> FriendsResponse {
        return try await performRequest(endpoint: "/api/users/friends/")
    }
    
    /// Gets all friend requests (sent and received) (GET /api/friend-requests/)
    func getFriendRequests() async throws -> [FriendRequest] {
        let response: FriendRequestsListResponse = try await performRequest(endpoint: "/api/friend-requests/")
        return response.results
    }
    
    /// Accepts a pending friend request (POST /api/friend-requests/{id}/accept/)
    func acceptFriendRequest(requestId: Int) async throws -> [String: String] {
        return try await performRequest(
            endpoint: "/api/friend-requests/\(requestId)/accept/",
            method: "POST"
        )
    }
    
    /// Rejects a pending friend request (POST /api/friend-requests/{id}/reject/)
    func rejectFriendRequest(requestId: Int) async throws -> [String: String] {
        return try await performRequest(
            endpoint: "/api/friend-requests/\(requestId)/reject/",
            method: "POST"
        )
    }

    // MARK: - Location Endpoints
    
    /// Gets all locations (GET /api/locations/)
    func getLocations() async throws -> [LocationResponse] {
        let response: LocationsListResponse = try await performRequest(
            endpoint: "/api/locations/",
            requiresAuth: false
        )
        return response.results
    }
    
    /// Gets a specific location by ID (GET /api/locations/{id}/)
    func getLocation(id: String) async throws -> LocationResponse {
        return try await performRequest(
            endpoint: "/api/locations/\(id)/",
            requiresAuth: false
        )
    }
    
    /// Gets all images for a location (GET /api/locations/{id}/images/)
    func getLocationImages(locationId: String) async throws -> LocationImagesResponse {
        return try await performRequest(
            endpoint: "/api/locations/\(locationId)/images/",
            requiresAuth: false
        )
    }
    
    /// Marks a location as visited with optional images (POST /api/locations/{id}/visit/)
    func visitLocation(
        locationId: String,
        note: String? = nil,
        images: [[String: String]]? = nil
    ) async throws -> LocationVisitResponse {
        var body: [String: Any] = [:]
        if let note = note {
            body["note"] = note
        }
        if let images = images {
            body["images"] = images
        }
        
        return try await performRequest(
            endpoint: "/api/locations/\(locationId)/visit/",
            method: "POST",
            body: body
        )
    }

    // MARK: - Visit Endpoints
    
    /// Gets the current user's visit history (GET /api/visits/)
    func getVisits() async throws -> [VisitResponse] {
        return try await performRequest(endpoint: "/api/visits/")
    }

    // MARK: - Image Endpoints
    
    /// Generates a presigned S3 URL for uploading an image (POST /api/users/generate_upload_url/)
    func generateUploadURL(filename: String) async throws -> UploadURLResponse {
        return try await performRequest(
            endpoint: "/api/users/generate_upload_url/",
            method: "POST",
            body: ["filename": filename]
        )
    }
    
    /// Uploads an image to S3 using a presigned URL
    func uploadImageToS3(imageData: Data, presignedURL: String) async throws {
        guard let url = URL(string: presignedURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.httpError((response as? HTTPURLResponse)?.statusCode ?? 500, "Failed to upload image")
        }
    }
    
    /// Gets the current user's images (GET /api/images/)
    func getImages() async throws -> [ImageResponse] {
        return try await performRequest(endpoint: "/api/images/")
    }
    
    /// Creates an image record (POST /api/images/)
    func createImage(visitId: Int, imageUrl: String, description: String = "") async throws -> ImageResponse {
        return try await performRequest(
            endpoint: "/api/images/",
            method: "POST",
            body: [
                "visit": visitId,
                "image_url": imageUrl,
                "description": description
            ]
        )
    }

    // MARK: - Achievement Endpoints
    
    /// Gets all achievements (GET /api/achievements/)
    func getAchievements() async throws -> [AchievementResponse] {
        let response: AchievementsListResponse = try await performRequest(
            endpoint: "/api/achievements/",
            requiresAuth: false
        )
        return response.results
    }
    
}
