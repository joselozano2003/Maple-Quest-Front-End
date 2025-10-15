//
//  Achievement.swift
//  Maple-Quest
//
//  Created by Matias Campuzano on 2025-10-14.
//

import Foundation
import SwiftUI

// This struct defines a single achievement
struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let requiredVisits: Int
    let color: Color
}

// A list of all possible achievements in the app
let allAchievements: [Achievement] = [
    Achievement(title: "First Steps", description: "Visit your first landmark.", iconName: "figure.walk", requiredVisits: 1, color: .green),
    Achievement(title: "Explorer", description: "Visit all 3 initial landmarks.", iconName: "map.fill", requiredVisits: 3, color: .blue),
]
