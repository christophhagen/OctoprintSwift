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

extension ServerInformation: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try container.decode(Version.self, forKey: .version)
        do {
            let isInSafeMode = try container.decode(Bool.self, forKey: .safeMode)
            guard !isInSafeMode else {
                throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.safeMode], debugDescription: "Found boolean, but value was not false"))
            }
            self.safeMode = nil
        } catch {
            self.safeMode = try container.decode(SafeMode.self, forKey: .safeMode)
        }
    }

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case safeMode = "safemode"
    }
}

extension ServerInformation: Equatable {
    
}
