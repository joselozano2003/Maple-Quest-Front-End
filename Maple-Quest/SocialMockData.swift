//
//  SocialMockData.swift
//  Maple-Quest
//
//  Created by Matias on 10/20/25.
//

import Foundation

// A simple user model for social features (Your existing struct)
struct SocialUser: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var profileIcon: String
}

// ----------------------------------------------------
// --- NEW LEADERBOARD STRUCTURE (REQUIRED FOR ACHIEVEMENTSVIEW) ---
// ----------------------------------------------------

// Structure used specifically for the Leaderboard section
struct LeaderboardFriend: Identifiable {
    let id = UUID()
    let name: String
    let visitedCount: Int // This is the crucial missing property
    let profileImage: String // This is the new name for the icon
}

// ----------------------------------------------------
// --- MOCK DATA ---
// ----------------------------------------------------

// A list of all users in the "database" that you can search for
let mockAllUsers: [SocialUser] = [
    SocialUser(name: "Camila", profileIcon: "person.fill.viewfinder"),
    SocialUser(name: "Matias", profileIcon: "person.fill.build"),
    SocialUser(name: "Eugene", profileIcon: "person.fill.laptopcomputer"),
    SocialUser(name: "Jose", profileIcon: "person.fill.music.note"),
    SocialUser(name: "David", profileIcon: "person.fill.books"),
    SocialUser(name: "Sarah", profileIcon: "person.fill.badge.plus"),
    SocialUser(name: "Mike", profileIcon: "person.fill.mic")
]

// A list of users who have sent you a friend request
let mockRequests: [SocialUser] = [
    SocialUser(name: "David", profileIcon: "person.fill.books"),
    SocialUser(name: "Sarah", profileIcon: "person.fill.badge.plus")
]

// A list of users who are already your friends
let mockCurrentFriends: [SocialUser] = [
    SocialUser(name: "Camila", profileIcon: "person.fill.viewfinder"),
    SocialUser(name: "Matias", profileIcon: "person.fill.build")
]

// The mock data array specifically for the Achievements leaderboard
let mockFriends: [LeaderboardFriend] = [
    // This is the placeholder for the current user. Its count is updated dynamically.
    LeaderboardFriend(name: "You (John)", visitedCount: 2, profileImage: "person.crop.circle.fill"),
    LeaderboardFriend(name: "Alice", visitedCount: 5, profileImage: "person.crop.circle.fill"),
    LeaderboardFriend(name: "Bob", visitedCount: 3, profileImage: "person.crop.circle.fill"),
    LeaderboardFriend(name: "Charlie", visitedCount: 1, profileImage: "person.crop.circle.fill")
].sorted { $0.visitedCount > $1.visitedCount } // Sort descending by visits
