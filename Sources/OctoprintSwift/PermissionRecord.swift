import Foundation

struct PermissionRecord {

    /// The permission’s identifier
    let key: String

    /// The permission’s name
    let name: String

    /// Whether the permission should be considered dangerous due to a high responsibility (true) or not (false).
    let dangerous: Bool

    /// List of group identifiers for which this permission is enabled by default
    let default_groups: [String]

    /// Human readable description of the permission
    let description: String

    /// Needs assigned to the permission
    let needs: Needs
}
