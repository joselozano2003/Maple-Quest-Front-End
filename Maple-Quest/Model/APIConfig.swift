//
//  APIConfig.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 11/5/25.
//

import Foundation

struct APIConfig {
    // Update this URL to match your Django backend
    // For local development: "http://localhost:8000"
    // For production: "https://your-backend-domain.com"
    static let baseURL = "http://localhost:8000" // only replace "localhost" with ur IP Address, u can get ur IP by putting this command in ur terminal: "ipconfig getifaddr en0"
}
