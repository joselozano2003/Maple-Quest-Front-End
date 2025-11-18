import SwiftUI

struct FriendsView: View {
    @State private var friends: [Friend] = []
    @State private var pendingRequests: [FriendRequest] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showAddFriend = false

    var body: some View {
        List {
            if !pendingRequests.isEmpty {
                Section(header: Text("Pending Requests")) {
                    ForEach(pendingRequests) { request in
                        FriendRequestRow(request: request, onAccept: acceptRequest, onReject: rejectRequest)
                    }
                }
            }

            Section(header: Text("My Friends")) {
                if isLoading && friends.isEmpty {
                    ProgressView("Loading friends...")
                } else if friends.isEmpty {
                    Text("You don't have any friends yet! Tap + to add one.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(friends) { friend in
                        FriendRow(friend: friend)
                    }
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Friends")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showAddFriend = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            Task {
                await loadFriendsAndRequests()
            }
        }
        .sheet(isPresented: $showAddFriend) {
            AddFriendView(onFriendAdded: {
                Task {
                    await loadFriendsAndRequests()
                }
            })
        }
    }
    
    func loadFriendsAndRequests() async {
        isLoading = true
        errorMessage = nil
        do {
            let friendsResponse = try await APIService.shared.getFriends()
            self.friends = friendsResponse.friends
            
            // NOTE: Replace this mock with a call to your real backend endpoint
            // to fetch pending friend requests (e.g., /api/friend-requests/pending/)
            self.pendingRequests = [FriendRequest.sample]
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func acceptRequest(request: FriendRequest) {
        Task {
            errorMessage = nil
            do {
                _ = try await APIService.shared.acceptFriendRequest(requestId: request.id)
                // Remove from pending list
                pendingRequests.removeAll { $0.id == request.id }
                // Reload friends list to show the new friend
                await loadFriendsAndRequests()
            } catch {
                errorMessage = "Failed to accept request: \(error.localizedDescription)"
            }
        }
    }

    func rejectRequest(request: FriendRequest) {
        // NOTE: You would need a rejectFriendRequest method in APIService here.
        // For now, only the UI element is removed:
        pendingRequests.removeAll { $0.id == request.id }
    }
}

// --- Supporting Views ---

struct FriendRow: View {
    let friend: Friend
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                Text(friend.firstName ?? (friend.email.split(separator: "@").first.map(String.init) ?? "Friend"))
                    .fontWeight(.medium)
                Text(friend.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct FriendRequestRow: View {
    let request: FriendRequest
    let onAccept: (FriendRequest) -> Void
    let onReject: (FriendRequest) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(request.senderEmail) wants to be friends.")
                    .fontWeight(.medium)
                Text("Pending")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            Spacer()
            
            Button("Accept") {
                onAccept(request)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            
            Button("Reject") {
                onReject(request)
            }
            .buttonStyle(.bordered)
            .foregroundColor(.red)
        }
    }
}
