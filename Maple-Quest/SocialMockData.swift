//
//  SocialMockData.swift
//  Maple-Quest
//
//  Created by Matias on 10/20/25.
//

import Foundation

struct SocialUser: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var profileIcon: String
}

struct LeaderboardFriend: Identifiable {
    let id = UUID()
    let name: String
    let visitedCount: Int 
    let profileImage: String 
}

let mockAllUsers: [SocialUser] = [
    SocialUser(name: "Camila", profileIcon: "person.fill.viewfinder"),
    SocialUser(name: "Matias", profileIcon: "person.fill.build"),
    SocialUser(name: "Eugene", profileIcon: "person.fill.laptopcomputer"),
    SocialUser(name: "Jose", profileIcon: "person.fill.music.note"),
    SocialUser(name: "David", profileIcon: "person.fill.books"),
    SocialUser(name: "Sarah", profileIcon: "person.fill.badge.plus"),
    SocialUser(name: "Mike", profileIcon: "person.fill.mic")
]

let mockRequests: [SocialUser] = [
    SocialUser(name: "David", profileIcon: "person.fill.books"),
    SocialUser(name: "Sarah", profileIcon: "person.fill.badge.plus")
]

let mockCurrentFriends: [SocialUser] = [
    SocialUser(name: "Camila", profileIcon: "person.fill.viewfinder"),
    SocialUser(name: "Matias", profileIcon: "person.fill.build")
]

let mockFriends: [LeaderboardFriend] = [
    LeaderboardFriend(name: "You (John)", visitedCount: 2, profileImage: "person.crop.circle.fill"),
    LeaderboardFriend(name: "Alice", visitedCount: 5, profileImage: "person.crop.circle.fill"),
    LeaderboardFriend(name: "Bob", visitedCount: 3, profileImage: "person.crop.circle.fill"),
    LeaderboardFriend(name: "Charlie", visitedCount: 1, profileImage: "person.crop.circle.fill")
].sorted { $0.visitedCount > $1.visitedCount } 
