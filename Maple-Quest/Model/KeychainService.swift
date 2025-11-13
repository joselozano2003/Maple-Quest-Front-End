//
//  KeychainService.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 11/5/25.
//

import Foundation
import Security

class KeychainService {
    private let service = "com.maplequest.app"
    
    private enum Keys {
        static let accessToken = "access_token"
        static let refreshToken = "refresh_token"
        static let userData = "user_data"
    }
    
    // MARK: - Token Management
    func saveTokens(access: String, refresh: String) {
        save(key: Keys.accessToken, value: access)
        save(key: Keys.refreshToken, value: refresh)
    }
    
    func getAccessToken() -> String? {
        return get(key: Keys.accessToken)
    }
    
    func getRefreshToken() -> String? {
        return get(key: Keys.refreshToken)
    }
    
    // MARK: - User Data Management
    func saveUserData(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            save(key: Keys.userData, data: encoded)
        }
    }
    
    func getUserData() -> User? {
        if let data = getData(key: Keys.userData),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return nil
    }
    
    // MARK: - Clear All
    func clearAll() {
        delete(key: Keys.accessToken)
        delete(key: Keys.refreshToken)
        delete(key: Keys.userData)
    }
    
    // MARK: - Private Keychain Operations
    private func save(key: String, value: String) {
        let data = value.data(using: .utf8)!
        save(key: key, data: data)
    }
    
    private func save(key: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing item first
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func get(key: String) -> String? {
        if let data = getData(key: key) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    private func getData(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            return result as? Data
        }
        return nil
    }
    
    private func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}