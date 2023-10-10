import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public actor OctoprintClient {

    public let url: URL

    public let apiKey: String

    public let session: URLSession

    public let decoder: JSONDecoder

    public init(url: URL, apiKey: String, session: URLSession = .shared) {
        self.url = url
        self.apiKey = apiKey
        self.session = session
        self.decoder = .init()
    }

    // MARK: Information

    /**
     Retrieve information regarding server and API version.

     Returns a JSON object with three keys, `api` containing the API version, `server` containing the server version, `text` containing the server version including the prefix `OctoPrint` (to determine that this is indeed a genuine OctoPrint instance).
     */
    public func getVersion() async throws -> VersionResponse {
        try await requestAndConvert(to: .apiVersion)
    }

    /**
     Retrieve information regarding server status.

     Returns an object with two keys, `version` containing the server version and `safemode` containing one of `settings`, `incomplete_startup` or `flag` to indicate the reason the server is running in safe mode, or the boolean value of `false` if it’s not running in safe mode.
     */
    public func getServerInformation() async throws -> ServerInformation {
        try await requestAndConvert(to: .serverInformation)
    }

    /**
     Revokes an existing application key.

     Must belong to the user issuing the command, unless the user has admin rights in which case they may revoke any application key in the system.
     - Parameter key: The key to revoke
     - Note: Requires user rights.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/bundledplugins/appkeys.html#issue-an-application-key-command)
     */
    public func revokeApplicationKey(key: String) async throws {
        try await applicationKeysCommand(.revoke, key: key)
    }

    /**
     Generates a new application key for the user.

     - Parameter applicationIdentifier: The application identifier for which to generate a key.
     - Note: Requires user rights.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/bundledplugins/appkeys.html#issue-an-application-key-command)
     */
    public func generateApplicationKey(applicationIdentifier: String) async throws {
        try await applicationKeysCommand(.generate, key: applicationIdentifier)
    }

    private func applicationKeysCommand(_ command: ApplicationKeyCommand.Command, key: String) async throws {
        let command = ApplicationKeyCommand(command: command, key: key)
        let request = try request(to: .applicationKeysCommand, body: command)
        let code = try await session.perform(request: request).code
        guard code == 204 else {
            throw OctoprintError.invalidResponse
        }
    }

    /**
     Fetches a list of existing application keys and pending requests registered in the system for the current user.

     - Parameter forAllUsers: If the user has administrator rights, fetches a list of **all** application keys and pending requests registered in the system for any user.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/bundledplugins/appkeys.html#fetch-list-of-existing-application-keys)
     */
    public func fetchListOfApplicationKeys(forAllUsers: Bool) async throws -> ListResponse {
        try await requestAndConvert(to: forAllUsers ? .fetchApplicationKeysForAllUsers : .fetchApplicationKeys)
    }

    // MARK: Networking

    private func request<T>(to path: Route, method: HTTPMethod = .post, body: T) throws -> URLRequest where T: Encodable {
        var request = try URLRequest(url: url, path: path, method: method, body: body)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        return request
    }

    private func requestAndConvert<T>(to path: Route, method: HTTPMethod = .post) async throws -> T where T: Decodable {
        var request = URLRequest(url: url, path: path, method: method)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw OctoprintError.invalidResponse
        }
        switch response.statusCode {
        case 200:
            return try decoder.decode(T.self, from: data)
        case 403:
            throw OctoprintError.invalidCredentials
        default:
            throw OctoprintError.invalidResponse
        }
    }
}
