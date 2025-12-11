//
//  Achievements.swift
//  Maple-Quest
//
//  Created by Matias
//

import SwiftUI
// Helper struct to normalize data between "Me" (Local) and "Friends" (Backend)
struct LeaderboardEntry: Identifiable {
    let id: String
    let name: String
    let score: Int
    let imageURL: String?
    let isMe: Bool
}
struct AchievementsView: View {
    @Binding var visitedLandmarks: [String]
    @EnvironmentObject var authService: AuthService // Need this to get "My" name/photo
    
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
                    VStack(alignment: .leading) {
                        Text("Achievements")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                            .padding(.bottom, 8)
                    }
                    
                    // --- LEADERBOARD SECTION ---
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Leaderboard")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.yellow)
                        }
                        
                        // We pass "me" details so the leaderboard can build the entry
                        LeaderboardView(
                            myVisitCount: myVisitCount,
                            myName: authService.currentUser?.firstName ?? "You",
                            myPhotoData: authService.currentUser?.profileImageData
                        )
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
                                .foregroundColor(.black)
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
                                .foregroundColor(.black)
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
// MARK: - Subviews
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
                        .foregroundColor(isUnlocked ? .black : .gray)
                    
                    Spacer()
                    
                    if isUnlocked {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(achievement.level.color)
                    }
                }
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
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
                        .foregroundColor(.gray)
                        .frame(width: 60, alignment: .trailing)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(isUnlocked ? 0.05 : 0.01), radius: 5, x: 0, y: 2)
        .saturation(isUnlocked ? 1.0 : 0.0)
        .opacity(isUnlocked ? 1.0 : 0.8)
    }
}
struct LeaderboardView: View {
    let myVisitCount: Int
    let myName: String
    let myPhotoData: Data?
    
    @State private var leaderboardEntries: [LeaderboardEntry] = []
    @State private var isLoading = true
    
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
                    .padding(.leading, 45)

                Text("Landmarks")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 80, alignment: .center)
            }
            .padding(.horizontal, 10)
            .padding(.top, 2)
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            } else if leaderboardEntries.isEmpty {
                // This shouldn't happen because "You" are always an entry
                Text("No data available")
                    .foregroundColor(.black)
            } else {
                ForEach(Array(leaderboardEntries.enumerated()), id: \.element.id) { index, entry in
                    
                    HStack(spacing: 12) {
                        
                        Text("\(index + 1)")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 20)
                        // Profile Image (Handles both URL and Local Data)
                        Group {
                            if entry.isMe,
                               let data = myPhotoData,
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            }
                            else if let urlString = entry.imageURL,
                                    let url = URL(string: urlString) {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                            }
                            else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundColor(entry.isMe ? .red : .blue)
                            }
                        }
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        // Name
                        Text(entry.isMe ? "You" : entry.name)
                            .font(.headline)
                            .fontWeight(entry.isMe ? .bold : .regular)
                            .foregroundColor(entry.isMe ? .black : .gray)
                        
                        HStack(spacing: 6) {
                            Text(entry.isMe ? "You" : entry.name)
                                .font(.headline)
                                .fontWeight(entry.isMe ? .bold : .regular)
                            
                            if let medal = medalForRank(index + 1) {
                                Text(medal)
                                    .font(.headline)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                                                
                        Text("\(entry.score)")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.black.opacity(0.7))
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(entry.isMe ? Color.red.opacity(0.2) : Color.blue.opacity(0.1))
                            .cornerRadius(20)
                            .frame(width: 80, alignment: .center)
                        
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                    .background(entry.isMe ? Color(.systemGray5).opacity(0.6) : Color.white)
                    .cornerRadius(10)
                    
                    if index != leaderboardEntries.count - 1 {
                        Divider().padding(.leading, 30)
                    }
                }
            }
        }
        .onAppear { loadLeaderboard() }
    }
    
    func loadLeaderboard() {
        Task {
            do {
                // 1. Fetch friends from backend
                let response = try await APIService.shared.getFriends()
                let friends = response.friends
                
                // 2. Convert Friends to LeaderboardEntry
                var entries = friends.map { friend in
                    LeaderboardEntry(
                        id: friend.user_id,
                        name: friend.displayName,
                        score: friend.points, // Using the points from backend
                        imageURL: friend.profile_pic_url,
                        isMe: false
                    )
                }
                
                // 3. Create "Me" entry
                let me = LeaderboardEntry(
                    id: "me",
                    name: myName,
                    score: myVisitCount, // Using local count
                    imageURL: nil, // Handled separately in view via myPhotoData
                    isMe: true
                )
                
                // 4. Combine and Sort (Highest score first)
                entries.append(me)
                entries.sort { $0.score > $1.score }
                
                // 5. Update UI
                await MainActor.run {
                    self.leaderboardEntries = entries
                    self.isLoading = false
                }
                
            } catch {
                print("Failed to load leaderboard: \(error)")
                // Even if fetch fails, show "Me"
                let me = LeaderboardEntry(id: "me", name: myName, score: myVisitCount, imageURL: nil, isMe: true)
                await MainActor.run {
                    self.leaderboardEntries = [me]
                    self.isLoading = false
                }
            }
        }
    }
}
#Preview {
    AchievementsView(visitedLandmarks: .constant(["Niagara Falls", "Banff National Park"]))
        .environmentObject(AuthService.shared) // Needed for preview
}


