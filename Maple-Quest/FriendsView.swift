import SwiftUI

struct FriendsView: View {
    @State private var friends: [Friend] = []
    @State private var pendingRequests: [FriendRequest] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showAddFriend = false
    @StateObject private var authService = AuthService.shared

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
            // Load friends
            let friendsResponse = try await APIService.shared.getFriends()
            self.friends = friendsResponse.friends
            
            // Load all friend requests
            let allRequests = try await APIService.shared.getFriendRequests()
            
            // Filter to show only pending requests where current user is the recipient
            // (Don't show requests that the current user sent)
            if let backendUserId = authService.getBackendUserId() {
                self.pendingRequests = allRequests.filter { request in
                    request.isPending && request.to_user == backendUserId
                }
            } else {
                // Fallback: show all pending requests if we can't get user ID
                self.pendingRequests = allRequests.filter { $0.isPending }
            }
            
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
        Task {
            errorMessage = nil
            do {
                _ = try await APIService.shared.rejectFriendRequest(requestId: request.id)
                // Remove from pending list
                pendingRequests.removeAll { $0.id == request.id }
            } catch {
                errorMessage = "Failed to reject request: \(error.localizedDescription)"
            }
        }
    }
}

// --- Supporting Views ---

struct FriendRow: View {
    let friend: Friend
    
    var body: some View {
        HStack {
            // Profile image or placeholder
            if let profileUrl = friend.profile_pic_url, let url = URL(string: profileUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(friend.displayName)
                    .fontWeight(.medium)
                Text(friend.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Show points
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
                Text("\(friend.points)")
                    .font(.caption)
                    .foregroundColor(.secondary)
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
            // Profile image
            if let profileUrl = request.from_user_details?.profile_pic_url, 
               let url = URL(string: profileUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(request.senderName)
                    .fontWeight(.medium)
                if let email = request.from_user_details?.email {
                    Text(email)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text("Pending")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Button("Accept") {
                    onAccept(request)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .controlSize(.small)
                
                Button("Reject") {
                    onReject(request)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
                .controlSize(.small)
            }
        }
        .padding(.vertical, 4)
    }
}
