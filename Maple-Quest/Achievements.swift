//
//  Achievements.swift
//  Maple-Quest
//
//  Created by Matias
//

import SwiftUI

struct AchievementsView: View {

    @Binding var visitedLandmarks: [String]
    
    // We get the user's current count from the binding
    var myVisitCount: Int {
        visitedLandmarks.count
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) { // Added more spacing
                    
                    // --- NEW LEADERBOARD SECTION ---
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Leaderboard")
                                .font(.title2)
                                .fontWeight(.bold)
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.yellow)
                        }
                        
                        // Pass the user's real count to the leaderboard view
                        LeaderboardView(myVisitCount: myVisitCount)
                    }
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(12)
                    
                    // --- EXISTING ACHIEVEMENTS ---
                    VStack(alignment: .leading, spacing: 16) {
                        Text("My Milestones")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        
                        // Loop through all possible achievements
                        ForEach(allAchievements) { achievement in
                            // Check if the user has visited enough landmarks
                            let isUnlocked = visitedLandmarks.count >= achievement.requiredVisits
                            
                            AchievementRow(achievement: achievement, isUnlocked: isUnlocked)
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .background(Color(hex: "EAF6FF"))
            .navigationTitle("Achievements")
        }
    }
}

// --- NEW LEADERBOARD VIEW ---
func medalForRank(_ rank: Int) -> String? {
    switch rank {
    case 1: return "🥇"
    case 2: return "🥈"
    case 3: return "🥉"
    default: return nil
    }
}

struct LeaderboardView: View {
    
    // Get the user's real count
    let myVisitCount: Int
    
    // Use the mock data for now
    // In a real app, this data would be fetched from your server
    @State private var friends = mockFriends

    var body: some View {
        VStack(spacing: 12) {
            // Loop through the mock friends list
            ForEach(Array(friends.enumerated()), id: \.element.id) { index, friend in
                
                // This logic dynamically updates the "You" row
                // with your real visited count
                let isMe = (friend.name == "You (John)")
                let score = isMe ? myVisitCount : friend.visitedCount
                
                HStack(spacing: 12) {
                    Text("\(index + 1)")
                        .font(.headline)
                        .frame(width: 25)

                    Image(systemName: friend.profileImage)
                        .font(.title2)
                        .foregroundColor(.red)
                        .frame(width: 30)

                    // Name + Medal beside it
                    HStack(spacing: 6) {
                        Text(isMe ? "You" : friend.name)
                            .font(.headline)
                            .fontWeight(isMe ? .bold : .regular)

                        if let medal = medalForRank(index + 1) {
                            Text(medal)
                                .font(.headline)
                        }
                    }

                    Spacer()

                    Text("\(score)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(20)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .background(
                    isMe
                    ? Color(.systemGray5).opacity(0.6)
                    : Color.white
                )
                .cornerRadius(10)
                if index != friends.count - 1 {
                    Divider()
                }
            }
        }
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievement.iconName)
                .font(.largeTitle)
                .foregroundColor(isUnlocked ? achievement.color : .gray.opacity(0.5))
                .frame(width: 50)
            
            VStack(alignment: .leading) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(isUnlocked ? .primary : .gray)
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(achievement.color)
                    .font(.title)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray.opacity(0.5))
                    .font(.title)
            }
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(12)
        // fade if it's locked
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}

#Preview {
    AchievementsView(visitedLandmarks: .constant(["Niagara Falls", "Banff National Park"]))
}
