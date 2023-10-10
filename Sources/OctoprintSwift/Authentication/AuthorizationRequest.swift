import Foundation

struct AuthorizationRequest {

    /// Application identifier to use for the request
    let app: String

    /// User identifier/name to restrict the request to
    let user: String?
}

extension AuthorizationRequest: Codable {
    
}
