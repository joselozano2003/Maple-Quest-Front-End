//
//  User.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 10/7/25.
//


import Foundation
import SwiftUI

struct User: Identifiable, Codable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var location: String
    var phoneCode: String
    var phoneNumber: String
    var avatarSystemImage: String // e.g. "person.crop.circle.fill"
    
    // Computed properties for convenience
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var formattedPhone: String {
        "\(phoneCode) \(phoneNumber)"
    }
    
    // Example static mock for previews or testing
    static let sample = User(
        id: UUID(),
        firstName: "Leonardo",
        lastName: "Ahmed",
        email: "leonardo@gmail.com",
        location: "Sylhet Bangladesh",
        phoneCode: "+88",
        phoneNumber: "01758-000666",
        avatarSystemImage: "person.crop.circle.fill"
    )
}
