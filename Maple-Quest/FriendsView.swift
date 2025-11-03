//
//  FriendsView.swift
//  Maple-Quest
//
//  Created by Matias on 10/20/25
//

import SwiftUI

struct FriendsView: View {
    
    // --- State for Search ---
    @State private var searchText = ""
    
    // --- State for Mock Data ---
    // In a real app, these would be loaded from your server.
    @State private var requests = mockRequests
    @State private var friends = mockCurrentFriends
    @State private var allUsers = mockAllUsers
    
    // Filter for search results
    var searchResults: [SocialUser] {
        if searchText.isEmpty {
            return [] // Don't show anyone if search is empty
        }
        // Filter all users who are not already friends or have a pending request
        return allUsers.filter { user in
            user.name.localizedCaseInsensitiveContains(searchText) &&
            !friends.contains(user) &&
            !requests.contains(user)
        }
    }
    
    var body: some View {
        List {
            // --- SECTION 1: FRIEND REQUESTS ---
            Section(header: Text("Friend Requests")) {
                if requests.isEmpty {
                    Text("No pending requests")
                        .foregroundColor(.gray)
                }
                ForEach(requests) { user in
                    HStack {
                        Image(systemName: user.profileIcon)
                            .font(.title2)
                            .frame(width: 30)
                        
                        Text(user.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        // Accept Button
                        Button(action: { accept(user) }) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(.plain) // Use plain style for list buttons
                        
                        // Reject Button
                        Button(action: { reject(user) }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // --- SECTION 2: SEARCH RESULTS ---
            // This section only appears when you are searching
            if !searchResults.isEmpty {
                Section(header: Text("Search Results")) {
                    ForEach(searchResults) { user in
                        HStack {
                            Image(systemName: user.profileIcon)
                                .font(.title2)
                                .frame(width: 30)
                            
                            Text(user.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            // Add Friend Button
                            Button(action: { add(user) }) {
                                Image(systemName: "person.fill.badge.plus")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            
            // --- SECTION 3: MY FRIENDS ---
            Section(header: Text("My Friends")) {
                if friends.isEmpty {
                    Text("Search to add friends!")
                        .foregroundColor(.gray)
                }
                ForEach(friends) { user in
                    HStack {
                        Image(systemName: user.profileIcon)
                            .font(.title2)
                            .frame(width: 30)
                        
                        Text(user.name)
                            .font(.headline)
                    }
                }
            }
        }
        .navigationTitle("Friends")
        // This modifier now keeps the search bar visible
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search for users"
        )
    }
    
    // --- Mock Functions ---
    // These functions simulate the backend logic by
    // moving users between your local lists.
    
    func accept(_ user: SocialUser) {
        requests.removeAll { $0.id == user.id }
        friends.append(user)
    }
    
    func reject(_ user: SocialUser) {
        requests.removeAll { $0.id == user.id }
    }
    
    func add(_ user: SocialUser) {
        // In a real app, this would send a request.
        // For the mock-up, we'll just remove them from the search list
        // to simulate that the request is "pending".
        print("Friend request sent to \(user.name)")
        allUsers.removeAll { $0.id == user.id }
    }
}

#Preview {
    NavigationStack {
        FriendsView()
    }
}
