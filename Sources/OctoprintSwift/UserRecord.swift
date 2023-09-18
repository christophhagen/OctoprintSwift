import Foundation

struct UserRecord {

    /// The user’s name
    let name: String

    /// Whether the user’s account is active (true) or not (false)
    let active: Bool

    /// Whether the user has user rights. Should always be true. Deprecated as of 1.4.0, use the users group instead.
    let user: Bool

    /// Whether the user has admin rights (true) or not (false). Deprecated as of 1.4.0, use the admins group instead.
    let admin: Bool

    /// The user’s personal API key
    let apikey: String?

    /// The user’s personal settings, might be an empty object.
    let settings: EmptyJSON

    /// Groups assigned to the user
    let groups: [String]

    /// Effective needs of the user
    let needs: Needs

    /// The list of permissions assigned to the user (note: this does not include implicit permissions inherit from groups).
    let permissions: [PermissionRecord]
}
