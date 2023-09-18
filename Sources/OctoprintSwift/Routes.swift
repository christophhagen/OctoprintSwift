import Foundation

enum Route: String {

    case login = "api/login"
    case logout = "api/logout"
    case currentUser = "api/currentuser"
    case apiVersion = "api/version"
    case serverInformation = "api/server"
    case probeWorkflowSupport = "plugin/appkeys/probe"
    case requestAppKey = "plugin/appkeys/request"
}
