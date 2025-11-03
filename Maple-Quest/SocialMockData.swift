//
//  SocialMockData.swift
//  Maple-Quest
//
//  Created by Matias on 10/20/25.
//

import Foundation

// A simple user model for social features
struct SocialUser: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var profileIcon: String
}

// --- MOCK DATA ---

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
