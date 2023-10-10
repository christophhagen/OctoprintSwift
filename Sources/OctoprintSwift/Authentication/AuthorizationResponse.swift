import Foundation

public struct AuthorizationResponse {

    /// Application token to use to poll for the decision.
    public let applicationToken: String

    /// An URL with which a dedicated auth dialog can be used for the user to log into and authorize the request.
    public let authenticationDialogUrl: URL
}

extension AuthorizationResponse: Codable {

    enum CodingKeys: String, CodingKey {
        case applicationToken = "app_token"
        case authenticationDialogUrl = "auth_dialog"
    }
}
