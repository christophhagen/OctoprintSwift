import Foundation

enum Route: RawRepresentable {

    case login
    case logout
    case currentUser
    case apiVersion
    case serverInformation
    case probeWorkflowSupport
    case requestAppKey
    case pollAppKeyRequestDecision(appToken: String)
    case decideExistingRequest(userToken: String)
    case applicationKeysCommand
    case fetchApplicationKeys
    case fetchApplicationKeysForAllUsers

    init?(rawValue: String) {
        return nil
    }

    var rawValue: String {
        switch self {
        case .login: return "api/login"
        case .logout: return "api/logout"
        case .currentUser: return "api/currentuser"
        case .apiVersion: return "api/version"
        case .serverInformation: return "api/server"
        case .probeWorkflowSupport: return "plugin/appkeys/probe"
        case .requestAppKey: return "plugin/appkeys/request"
        case .pollAppKeyRequestDecision(appToken: let token):
            return "plugin/appkeys/request/\(token)"
        case .decideExistingRequest(userToken: let token):
            return "/plugin/appkeys/decision/\(token)"
        case .applicationKeysCommand: return "/api/plugin/appkeys"
        case .fetchApplicationKeys: return "/api/plugin/appkeys"
        case .fetchApplicationKeysForAllUsers: return "/api/plugin/appkeys?all"
        }
    }
}
