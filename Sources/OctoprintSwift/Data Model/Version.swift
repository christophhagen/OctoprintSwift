import Foundation

public struct Version {

    public let major: Int

    public let minor: Int

    public let patch: Int?

    public init(major: Int, minor: Int, patch: Int? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

extension Version: RawRepresentable {

    public var rawValue: String {
        guard let patch else {
            return "\(major).\(minor)"
        }
        return "\(major).\(minor).\(patch)"
    }

    public init?(rawValue: String) {
        let parts = rawValue
            .trimmingCharacters(in: .whitespaces)
            .components(separatedBy: ".")
        guard parts.count == 2 || parts.count == 3 else {
            return nil
        }
        guard let major = Int(parts[0]),
              let minor = Int(parts[1]) else {
            return nil
        }
        self.major = major
        self.minor = minor
        guard parts.count == 3 else {
            self.patch = nil
            return
        }
        guard let patch = Int(parts[2]) else {
            return nil
        }
        self.patch = patch
    }
}

extension Version: Decodable {

}

extension Version: Encodable {

}

extension Version: Equatable {
    
}

extension Version: Hashable {

}

extension Version: Comparable {

    public static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major < rhs.major {
            return true
        }
        if lhs.major > rhs.major {
            return false
        }
        // Major version equal
        if lhs.minor < rhs.minor {
            return true
        }
        if lhs.minor > rhs.minor {
            return false
        }
        // Minor version equal
        guard let lhsPatch = lhs.patch, let rhsPatch = rhs.patch else {
            return false
        }
        return lhsPatch < rhsPatch
    }
}
