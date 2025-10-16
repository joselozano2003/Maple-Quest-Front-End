//
//  User.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 10/7/25.
//


import Foundation
import SwiftUI
import Contacts

struct User: Identifiable, Codable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var location: String
    var phoneCode: String
    var phoneNumber: String
    var profileImageData: Data? // e.g. "person.crop.circle.fill"
    
    // Computed properties for convenience
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
//    var formattedPhone: String {
//        "\(phoneCode) \(phoneNumber)"
//    }
    var formattedPhone: String {
        let digits = phoneNumber.filter(\.isNumber)
        
        // Basic North American formatting (XXX) XXX-XXXX
        if digits.count == 10 {
            let area = digits.prefix(3)
            let mid = digits.dropFirst(3).prefix(3)
            let end = digits.suffix(4)
            return "\(phoneCode) (\(area)) \(mid)-\(end)"
        } else {
            // fallback: just return the digits
            return "\(phoneCode) \(phoneNumber)"
        }
    }
    
    // Example static mock for previews or testing
    static let sample = User(
        id: UUID(),
        firstName: "John",
        lastName: "Smith",
        email: "john.smith@ucalgary.ca",
        location: "Calgary, AB, Canada",
        phoneCode: "+1",
        phoneNumber: "(403) 758-0006",
        profileImageData: nil
    )
}
