//
//  Achievement.swift
//  Maple-Quest
//
//  Created by Matias Campuzano on 2025-10-14.
//

import Foundation
import SwiftUI

// MARK: - Enums

enum AchievementLevel: String, CaseIterable {
    case bronze
    case silver
    case gold
    case platinum
    
    var color: Color {
        switch self {
        case .bronze: return Color(red: 0.8, green: 0.5, blue: 0.2)
        case .silver: return Color.gray
        case .gold: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .platinum: return Color(red: 0.2, green: 0.8, blue: 0.9)
        }
    }
}

enum AchievementCriteria {
    case visitCount(Int)          // e.g., Visit 5 places
    case specificLandmark(String) // e.g., Visit "Niagara Falls"
}

// MARK: - Achievement Struct

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let level: AchievementLevel
    let criteria: AchievementCriteria
}

// MARK: - Data Source

let allAchievements: [Achievement] = [
    
    // MARK: - MILESTONES (Count Based)
    
    Achievement(
        title: "First Steps",
        description: "Visit your first landmark.",
        iconName: "figure.walk",
        level: .bronze,
        criteria: .visitCount(1)
    ),
    Achievement(
        title: "Explorer",
        description: "Visit 5 different landmarks.",
        iconName: "map.fill",
        level: .silver,
        criteria: .visitCount(5)
    ),
    Achievement(
        title: "Adventurer",
        description: "Visit 10 different landmarks.",
        iconName: "binoculars.fill",
        level: .gold,
        criteria: .visitCount(10)
    ),
    Achievement(
        title: "True Canadian",
        description: "Visit all 17 landmarks.",
        iconName: "crown.fill",
        level: .platinum,
        criteria: .visitCount(17)
    ),

    // MARK: - BRONZE TIER (Accessible / Popular Spots)
    
    Achievement(
        title: "Mist Walker",
        description: "Experience the power of Niagara Falls.",
        iconName: "drop.fill",
        level: .bronze,
        criteria: .specificLandmark("Niagara Falls")
    ),
    Achievement(
        title: "Saddle Up",
        description: "Visit the iconic Scotiabank Saddledome.",
        iconName: "sportscourt.fill",
        level: .bronze,
        criteria: .specificLandmark("Scotiabank Saddledome")
    ),
    Achievement(
        title: "Maritime Magic",
        description: "Visit Peggy’s Cove Lighthouse.",
        iconName: "sailboat.fill",
        level: .bronze,
        criteria: .specificLandmark("Peggy’s Cove Lighthouse")
    ),
    Achievement(
        title: "Thunderous Drop",
        description: "Witness the height of Montmorency Falls.",
        iconName: "water.waves",
        level: .bronze,
        criteria: .specificLandmark("Montmorency Falls")
    ),

    // MARK: - SILVER TIER (Historic & Cultural Sites)
    
    Achievement(
        title: "Capital City",
        description: "Stand on Parliament Hill.",
        iconName: "building.columns.fill",
        level: .silver,
        criteria: .specificLandmark("Parliament Hill")
    ),
    Achievement(
        title: "Tides of Fundy",
        description: "Walk the ocean floor at Hopewell Rocks Provincial Park.",
        iconName: "water.waves.and.arrow.down",
        level: .silver,
        criteria: .specificLandmark("Hopewell Rocks Provincial Park")
    ),
    Achievement(
        title: "Urban Artisan",
        description: "Explore the shops of Granville Island.",
        iconName: "basket.fill",
        level: .silver,
        criteria: .specificLandmark("Granville Island")
    ),
    Achievement(
        title: "Castle Guard",
        description: "Find your way through Casa Loma.",
        iconName: "shield.checkerboard",
        level: .silver,
        criteria: .specificLandmark("Casa Loma")
    ),
    Achievement(
        title: "Star Fort",
        description: "Stand guard at the Halifax Citadel.",
        iconName: "star.square.fill",
        level: .silver,
        criteria: .specificLandmark("Halifax Citadel")
    ),

    // MARK: - GOLD TIER (Nature & Architecture)
    
    Achievement(
        title: "Sky High",
        description: "Look down from the CN Tower.",
        iconName: "building.2.fill",
        level: .gold,
        criteria: .specificLandmark("CN Tower")
    ),
    Achievement(
        title: "French Heritage",
        description: "Visit the historic Château Frontenac.",
        iconName: "bed.double.fill",
        level: .gold,
        criteria: .specificLandmark("Château Frontenac")
    ),
    Achievement(
        title: "Gothic Glory",
        description: "Admire the Notre-Dame Basilica of Montreal.",
        iconName: "sun.max.fill", // Stained glass representation
        level: .gold,
        criteria: .specificLandmark("Notre-Dame Basilica of Montreal")
    ),
    Achievement(
        title: "Green Thumb",
        description: "Wander through The Butchart Gardens.",
        iconName: "leaf.fill",
        level: .gold,
        criteria: .specificLandmark("The Butchart Gardens")
    ),
    Achievement(
        title: "Cliffhanger",
        description: "Cross the Capilano Suspension Bridge.",
        iconName: "figure.walk.diamond.fill",
        level: .gold,
        criteria: .specificLandmark("Capilano Suspension Bridge")
    ),

    // MARK: - PLATINUM TIER (Remote / Special Locations)
    
    Achievement(
        title: "Rocky Mountain High",
        description: "Explore the beauty of Banff National Park.",
        iconName: "mountain.2.fill",
        level: .platinum,
        criteria: .specificLandmark("Banff National Park")
    ),
    Achievement(
        title: "Star Gazer",
        description: "Experience the wild of Jasper National Park.",
        iconName: "moon.stars.fill",
        level: .platinum,
        criteria: .specificLandmark("Jasper National Park")
    ),
    Achievement(
        title: "Campus Life",
        description: "Visit the University of Calgary.",
        iconName: "graduationcap.fill",
        level: .platinum,
        criteria: .specificLandmark("University of Calgary")
    )
]
