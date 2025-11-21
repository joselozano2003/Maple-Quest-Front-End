//
//  Achievements.swift
//  Maple-Quest
//
//  Created by Matias
//

import SwiftUI

struct AchievementsView: View {

    @Binding var visitedLandmarks: [String]
    
    // User's current count from the binding
    var myVisitCount: Int {
        visitedLandmarks.count
    }
    
    // Filter for Unlocked Achievements
    var unlockedAchievements: [Achievement] {
        allAchievements.filter { isUnlocked($0) }
    }
    
    // Filter for Locked Achievements
    var lockedAchievements: [Achievement] {
        allAchievements.filter { !isUnlocked($0) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // --- LEADERBOARD SECTION ---
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Leaderboard")
                                .font(.title2)
                                .fontWeight(.bold)
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.yellow)
                        }
                        
                        LeaderboardView(myVisitCount: myVisitCount)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // --- UNLOCKED ACHIEVEMENTS ---
                    if !unlockedAchievements.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Unlocked")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            ForEach(unlockedAchievements) { achievement in
                                AchievementCard(
                                    achievement: achievement,
                                    isUnlocked: true,
                                    progress: 1.0,
                                    progressLabel: "Completed"
                                )
                            }
                        }
                    }
                    
                    // --- LOCKED ACHIEVEMENTS (Next Milestones) ---
                    if !lockedAchievements.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Next Milestones")
                                .font(.title2)
                                .fontWeight(.bold)
                                .opacity(0.8)
                            
                            ForEach(lockedAchievements) { achievement in
                                let progressValue = calculateProgress(achievement)
                                let progressLabel = calculateProgressLabel(achievement)
                                
                                AchievementCard(
                                    achievement: achievement,
                                    isUnlocked: false,
                                    progress: progressValue,
                                    progressLabel: progressLabel
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(hex: "EAF6FF"))
            .navigationTitle("Achievements")
        }
    }
    
    // MARK: - Logic Helpers
    
    func isUnlocked(_ achievement: Achievement) -> Bool {
        switch achievement.criteria {
        case .visitCount(let required):
            return visitedLandmarks.count >= required
        case .specificLandmark(let name):
            return visitedLandmarks.contains(name)
        }
    }
    
    func calculateProgress(_ achievement: Achievement) -> Double {
        switch achievement.criteria {
        case .visitCount(let required):
            return min(Double(visitedLandmarks.count) / Double(required), 1.0)
        case .specificLandmark:
            return 0.0 // Specific landmarks are binary (0 or 1)
        }
    }
    
    func calculateProgressLabel(_ achievement: Achievement) -> String {
        switch achievement.criteria {
        case .visitCount(let required):
            return "\(visitedLandmarks.count)/\(required)"
        case .specificLandmark:
            return "Not Visited"
        }
    }
}

func medalForRank(_ rank: Int) -> String? {
    switch rank {
    case 1: return "🥇"
    case 2: return "🥈"
    case 3: return "🥉"
    default: return nil
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let progress: Double
    let progressLabel: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Circle
            ZStack {
                Circle()
                    .fill(isUnlocked ? achievement.level.color.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.iconName)
                    .font(.title2)
                    .foregroundColor(isUnlocked ? achievement.level.color : .gray)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(achievement.title)
                        .font(.headline)
                        .foregroundColor(isUnlocked ? .primary : .gray)
                    
                    Spacer()
                    
                    if isUnlocked {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(achievement.level.color)
                    }
                }
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Progress Bar
                HStack {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 6)
                                .foregroundColor(Color.gray.opacity(0.2))
                            
                            // Fill track
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: geometry.size.width * CGFloat(progress), height: 6)
                                .foregroundColor(isUnlocked ? achievement.level.color : .gray)
                                .animation(.spring(), value: progress)
                        }
                    }
                    .frame(height: 6)
                    
                    Text(progressLabel)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .trailing)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(isUnlocked ? 0.05 : 0.01), radius: 5, x: 0, y: 2)
        // Fade out slightly if locked
        .saturation(isUnlocked ? 1.0 : 0.0)
        .opacity(isUnlocked ? 1.0 : 0.8)
    }
}

struct LeaderboardView: View {
    let myVisitCount: Int
    // Using the mock data from SocialMockData.swift
    @State private var friends = mockFriends

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Rank")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 30, alignment: .leading)

                Text("User")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 35)

                Text("Landmarks")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 80, alignment: .center)
            }
            .padding(.horizontal, 10)
            .padding(.top, 2)
            
            ForEach(Array(friends.enumerated()), id: \.element.id) { index, friend in
                
                // Check if this row represents the current user
                let isMe = (friend.name == "You (John)")
                let score = isMe ? myVisitCount : friend.visitedCount
                
                HStack(spacing: 12) {
                    Text("\(index + 1)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(width: 20)

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
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(20)
                        .frame(width: 80, alignment: .center)
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
                        .padding(.leading, 30)
                }
            }
        }
    }
}

#Preview {
    AchievementsView(visitedLandmarks: .constant(["Niagara Falls", "Banff National Park"]))
}
