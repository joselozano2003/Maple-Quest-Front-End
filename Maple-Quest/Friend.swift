//
//  Friend.swift
//  Maple-Quest
//
//  Created by Matias on 2025-10-20.
//

import Foundation

// A simple struct for the leaderboard
struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let profileImage: String
    let visitedCount: Int
}

// Mock data for the preview
let mockFriends: [Friend] = [
    Friend(name: "Camila", profileImage: "person.fill.viewfinder", visitedCount: 4),
    Friend(name: "Perales", profileImage: "person.fill.build", visitedCount: 3),
    Friend(name: "Matias", profileImage: "person.crop.circle.fill", visitedCount: 2),
    Friend(name: "Eugene", profileImage: "person.fill.laptopcomputer", visitedCount: 1),
    Friend(name: "Jose", profileImage: "person.fill.music.note", visitedCount: 1)
].sorted(by: { $0.visitedCount > $1.visitedCount }) // Sort by highest score
