//
//  AuthService.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 11/5/25.
//

import Foundation
import Combine

// MARK: - API Response Models
struct AuthResponse: Codable {
    let user: APIUser
    let tokens: TokenPair
    let message: String
}

struct TokenPair: Codable {
    let access: String
    let refresh: String
}

struct APIUser: Codable {
    let user_id: String
    let email: String
    let phone_no: String?
    let points: Int
    let created_at: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let phone_no: String?
}

// MARK: - Authentication Service
@MainActor
class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isInitialized = false
    
    private let baseURL = APIConfig.baseURL
    private let keychain = KeychainService()
    
    private init() {
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Status
    private func checkAuthenticationStatus() {
        if let accessToken = keychain.getAccessToken(),
           let userData = keychain.getUserData() {
            self.currentUser = userData
            self.isAuthenticated = true
        }
        self.isInitialized = true
    }
    
    // MARK: - Login
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = LoginRequest(email: email, password: password)
            let response: AuthResponse = try await performRequest(
                endpoint: "/auth/login/",
                method: "POST",
                body: request
            )
            
            // Store tokens and user data
            keychain.saveTokens(access: response.tokens.access, refresh: response.tokens.refresh)
            
            // Convert API user to local User model
            let user = User(
                id: UUID(), // Generate local UUID
                firstName: "", // API doesn't provide first/last name, will need to be updated
                lastName: "",
                email: response.user.email,
                location: "", // Not provided by API
                phoneCode: "+1", // Default
                phoneNumber: response.user.phone_no ?? "",
                profileImageData: nil
            )
            
            keychain.saveUserData(user)
            
            self.currentUser = user
            self.isAuthenticated = true
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Register
    func register(email: String, password: String, phoneNumber: String?) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = RegisterRequest(email: email, password: password, phone_no: phoneNumber)
            let response: AuthResponse = try await performRequest(
                endpoint: "/auth/register/",
                method: "POST",
                body: request
            )
            
            // Store tokens and user data
            keychain.saveTokens(access: response.tokens.access, refresh: response.tokens.refresh)
            
            // Convert API user to local User model
            let user = User(
                id: UUID(), // Generate local UUID
                firstName: "", // Will need to be updated later
                lastName: "",
                email: response.user.email,
                location: "",
                phoneCode: "+1",
                phoneNumber: response.user.phone_no ?? "",
                profileImageData: nil
            )
            
            keychain.saveUserData(user)
            
            self.currentUser = user
            self.isAuthenticated = true
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Logout
    func logout() {
        keychain.clearAll()
        currentUser = nil
        isAuthenticated = false
    }
    
    // MARK: - Refresh Token
    func refreshToken() async -> Bool {
        guard let refreshToken = keychain.getRefreshToken() else {
            logout()
            return false
        }
        
        do {
            let response: TokenPair = try await performRequest(
                endpoint: "/auth/token/refresh/",
                method: "POST",
                body: ["refresh": refreshToken]
            )
            
            keychain.saveTokens(access: response.access, refresh: response.refresh)
            return true
            
        } catch {
            logout()
            return false
        }
    }
    
    // MARK: - Generic API Request
    private func performRequest<T: Codable, U: Codable>(
        endpoint: String,
        method: String,
        body: U? = nil
    ) async throws -> T {
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authorization header if we have an access token (except for login/register)
        if !endpoint.contains("/auth/login/") && !endpoint.contains("/auth/register/") {
            if let accessToken = keychain.getAccessToken() {
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
        
        // Add body if provided
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            // Token might be expired, try to refresh
            if await refreshToken() {
                // Retry the request with new token
                if let accessToken = keychain.getAccessToken() {
                    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                    let (retryData, retryResponse) = try await URLSession.shared.data(for: request)
                    
                    guard let retryHttpResponse = retryResponse as? HTTPURLResponse,
                          retryHttpResponse.statusCode == 200 else {
                        throw AuthError.unauthorized
                    }
                    
                    return try JSONDecoder().decode(T.self, from: retryData)
                }
            }
            throw AuthError.unauthorized
        }
        
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            // Try to parse error message
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let error = errorData["error"] as? String {
                throw AuthError.serverError(error)
            }
            throw AuthError.serverError("HTTP \(httpResponse.statusCode)")
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Authentication failed"
        case .serverError(let message):
            return message
        }
    }
}