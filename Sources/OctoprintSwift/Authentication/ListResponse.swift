import Foundation

public struct ListResponse {

    public let keys: [KeyListEntry]

    public let pending: [PendingListEntry]
}

extension ListResponse: Decodable {

}

public struct KeyListEntry {

    /// API key
    public let apiKey: String

    /// Application identifier
    public let appId: String

    /// User ID of the key’s owner
    public let userId: String
}

extension KeyListEntry: Decodable {

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case appId = "app_id"
        case userId = "user_id"
    }
}

public struct PendingListEntry {

    /// Application identifier
    public let appId: String

    /// User ID of user who can grant or deny request
    public let userId: String?

    /// Token to grant or deny request
    public let userToken: String
}

extension PendingListEntry: Decodable {

    enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case userId = "user_id"
        case userToken = "user_token"
    }
}
