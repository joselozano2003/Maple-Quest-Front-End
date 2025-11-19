import Foundation

// MARK: - Friend Model

struct Friend: Identifiable, Codable {
    let user_id: String
    let email: String
    let first_name: String?
    let last_name: String?
    let phone_no: String?
    let points: Int
    let profile_pic_url: String?
    let created_at: String
    
    var id: String { user_id }
    
    var displayName: String {
        if let firstName = first_name, let lastName = last_name, !firstName.isEmpty, !lastName.isEmpty {
            return "\(firstName) \(lastName)"
        } else if let firstName = first_name, !firstName.isEmpty {
            return firstName
        } else if let lastName = last_name, !lastName.isEmpty {
            return lastName
        } else {
            return email
        }
    }
    
    static var sample: Friend {
        Friend(
            user_id: "sample-id",
            email: "friend@maple.com",
            first_name: "Friend",
            last_name: "Quest",
            phone_no: nil,
            points: 100,
            profile_pic_url: nil,
            created_at: "2025-11-19T00:00:00Z"
        )
    }
}

// MARK: - Friend Request Model

struct FriendRequest: Identifiable, Codable {
    let id: Int
    let from_user: String  // user_id of sender
    let to_user: String    // user_id of recipient
    let from_user_details: Friend?  // Full user info of sender
    let to_user_details: Friend?    // Full user info of recipient
    let status: String     // "pending", "accepted", "rejected"
    let created_at: String
    let updated_at: String
    
    var isPending: Bool { status == "pending" }
    var isAccepted: Bool { status == "accepted" }
    var isRejected: Bool { status == "rejected" }
    
    var senderName: String {
        from_user_details?.displayName ?? "Unknown User"
    }
    
    var recipientName: String {
        to_user_details?.displayName ?? "Unknown User"
    }
    
    static var sample: FriendRequest {
        FriendRequest(
            id: 201,
            from_user: "sample-sender-id",
            to_user: "sample-receiver-id",
            from_user_details: Friend.sample,
            to_user_details: nil,
            status: "pending",
            created_at: "2025-11-19T00:00:00Z",
            updated_at: "2025-11-19T00:00:00Z"
        )
    }
}
