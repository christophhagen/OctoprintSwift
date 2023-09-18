import Foundation

public struct ServerInformation {

    public let version: Version

    public let safeMode: SafeMode?

    public enum SafeMode: String, Codable {
        case settings = "settings"
        case incompleteStartup = "incomplete_startup"
        case flag = "flag"
    }
}

extension ServerInformation: Codable {

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case safeMode = "safemode"
    }
}

extension ServerInformation: Equatable {
    
}
