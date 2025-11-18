import Foundation

// MARK: - Friend Model

struct Friend: Identifiable, Codable {
    let id: Int
    let email: String
    let firstName: String?
    let lastName: String?
    let profileImageUrl: URL?
    
    // Coding Keys to map Swift camelCase to Python snake_case
    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImageUrl = "profile_image_url"
    }
    
    static var sample: Friend {
        Friend(
            id: 101,
            email: "friend@maple.com",
            firstName: "Friend",
            lastName: "Quest",
            profileImageUrl: nil
        )
    }
}

// MARK: - Friend Request Model

struct FriendRequest: Identifiable, Codable {
    let id: Int
    let senderEmail: String
    let receiverEmail: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case senderEmail = "sender_email"
        case receiverEmail = "receiver_email"
    }
    
    static var sample: FriendRequest {
        FriendRequest(
            id: 201,
            senderEmail: "pending@maple.com",
            receiverEmail: "user@maple.com",
            status: "pending"
        )
    }
}
