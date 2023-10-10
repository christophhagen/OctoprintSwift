import Foundation

public enum AuthorizationDecision {
    case denied
    case granted(apiKey: String)
}
