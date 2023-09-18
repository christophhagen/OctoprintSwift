import Foundation

public struct VersionResponse {

    public let api: Version

    public let server: Version

    public var octoprintVersionText: String {
        "OctoPrint \(server.rawValue)"
    }
}

extension VersionResponse: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(api.rawValue, forKey: .api)
        try container.encode(server.rawValue, forKey: .server)
        try container.encode(octoprintVersionText, forKey: .text)
    }

    enum CodingKeys: String, CodingKey {
        case api
        case server
        case text
    }
}

extension VersionResponse: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let apiString = try container.decode(String.self, forKey: .api)
        guard let api = Version(rawValue: apiString) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.api], debugDescription: "Invalid version string"))
        }
        self.api = api

        let serverString = try container.decode(String.self, forKey: .server)
        guard let server = Version(rawValue: serverString) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.server], debugDescription: "Invalid version string"))
        }
        self.server = server

        let serverVersionText = try container.decode(String.self, forKey: .text)
        guard self.octoprintVersionText == serverVersionText else {
            throw DecodingError.typeMismatch(Version.self, .init(codingPath: [CodingKeys.text], debugDescription: "The text version '\(serverVersionText)' does not match the server version '\(serverVersionText)'"))
        }
    }
}

extension VersionResponse: Equatable {
    
}
