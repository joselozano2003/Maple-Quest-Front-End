import Foundation

// MARK: - Friend-Related API Response Models

struct FriendRequestResponse: Codable {
    let message: String
    let friend_request: FriendRequest
}

struct FriendsResponse: Codable {
    let friends: [Friend]
    let count: Int
}

// MARK: - Error Types

enum APIError: LocalizedError {
    case invalidURL
    case unauthorized
    case invalidResponse
    case httpError(Int)
    case requestFailed

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
        case .requestFailed:
            return "Request failed due to bad parameters."
        }
    }
}

// MARK: - Main APIService Class

class APIService {
    static let shared = APIService()
    
    // Uses the existing APIConfig in your project
    private let baseURL = APIConfig.baseURL
    
    // Uses the existing KeychainService in your project
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

        if requiresAuth {
            // Using your existing KeychainService logic
            guard let token = keychain.getAccessToken() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
             if let errorBody = String(data: data, encoding: .utf8) {
                 print("HTTP Error \(httpResponse.statusCode). Response: \(errorBody)")
             }
            throw APIError.httpError(httpResponse.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Friend Endpoints

    /// Sends a friend request via email or phone number (POST /api/friend-requests/add_friend/).
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

    /// Gets the current user's friends list and count (GET /api/users/friends/).
    func getFriends() async throws -> FriendsResponse {
        return try await performRequest(
            endpoint: "/api/users/friends/"
        )
    }
    
    /// Accepts a specific pending friend request (POST /api/friend-requests/{request_id}/accept/).
    func acceptFriendRequest(requestId: Int) async throws -> [String: String] {
        // Assuming the response is simple (e.g., { "status": "accepted" })
        return try await performRequest(
            endpoint: "/api/friend-requests/\(requestId)/accept/",
            method: "POST"
        )
    }
}
