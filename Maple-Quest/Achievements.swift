//
//  Achievements.swift
//  Maple-Quest
//
//  Created by Matias 
//

import SwiftUI

struct AchievementsView: View {

    @Binding var visitedLandmarks: [String]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Loop through all possible achievements
                    ForEach(allAchievements) { achievement in
                        // Check if the user has visited enough landmarks to unlock this achievement
                        let isUnlocked = visitedLandmarks.count >= achievement.requiredVisits
                        
                        AchievementRow(achievement: achievement, isUnlocked: isUnlocked)
                    }
                }
                .padding()
            }
            .navigationTitle("Achievements")
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
        .background(Color(.systemGray6))
        .cornerRadius(12)
        // fade if it's locked
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}

#Preview {
    AchievementsView(visitedLandmarks: .constant(["Niagara Falls"]))
}
