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
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/api/version.html#version-information)
     */
    public func getVersion() async throws -> VersionResponse {
        try await requestAndConvert(to: .apiVersion, method: .get)
    }

    /**
     Retrieve information regarding server status.

     Returns an object with two keys, `version` containing the server version and `safemode` containing one of `settings`, `incomplete_startup` or `flag` to indicate the reason the server is running in safe mode, or the boolean value of `false` if it’s not running in safe mode.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/api/server.html#server-information)
     */
    public func getServerInformation() async throws -> ServerInformation {
        try await requestAndConvert(to: .serverInformation, method: .get)
    }

    // MARK: Connection

    /**
     Get connection settings.

     Retrieve the current connection settings, including information regarding the available baudrates and serial ports and the current connection state.

     - Note: Requires the `STATUS` permission.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/api/connection.html#get-connection-settings)
     */
    public func getConnectionSettings() async throws -> ConnectionStatus {
        try await requestAndConvert(to: .connectionStatus, method: .get)
    }

    /**
     Instructs OctoPrint to connect or, if already connected, reconnect to the printer.

     - Parameter port: Specific port to connect to. If not set the current `portPreference` will be used, or if no preference is available auto detection will be attempted.
     - Parameter baudrate: Specific baudrate to connect with. If not set the current `baudratePreference` will be used, or if no preference is available auto detection will be attempted.
     - Parameter printerProfile: Specific printer profile to use for connection. If not set the current default printer profile will be used.
     - Parameter save: Whether to save the request’s `port` and `baudrate` settings as new preferences. Defaults to `false`.
     - Parameter autoconnect:Whether to automatically connect to the printer on OctoPrint’s startup in the future. If not set no changes will be made to the current configuration.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/api/connection.html#issue-a-connection-command)
     */
    public func connect(
        port: String? = nil,
        baudrate: Int? = nil,
        printerProfile: String? = nil,
        save: Bool = false,
        autoconnect: Bool? = nil)
    async throws {
        let settings = Connect(command: .connect, port: port, baudrate: baudrate, printerProfile: printerProfile, save: save, autoconnect: autoconnect)
        try await requestAndExpectNoContent(route: .connectionStatus, body: settings)
    }

    /**
     Instructs OctoPrint to disconnect from the printer.

     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/api/connection.html#issue-a-connection-command)
     */
    public func disconnect() async throws {
        let command = Connect(command: .disconnect)
        try await requestAndExpectNoContent(route: .connectionStatus, body: command)
    }

    /**
     Fakes an acknowledgment message for OctoPrint in case one got lost on the serial line and the communication with the printer since stalled.

     This should only be used in “emergencies” (e.g. to save prints), the reason for the lost acknowledgment should always be properly investigated and removed instead of depending on this “symptom solver”.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/api/connection.html#issue-a-connection-command)
     */
    public func fakeAcknowledgement() async throws {
        let command = Connect(command: .fakeAck)
        try await requestAndExpectNoContent(route: .connectionStatus, body: command)
    }

    // MARK: Application keys

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
        try await requestAndExpectNoContent(route: .applicationKeysCommand, body: command)
    }

    /**
     Fetches a list of existing application keys and pending requests registered in the system for the current user.

     - Parameter forAllUsers: If the user has administrator rights, fetches a list of **all** application keys and pending requests registered in the system for any user.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/bundledplugins/appkeys.html#fetch-list-of-existing-application-keys)
     */
    public func fetchListOfApplicationKeys(forAllUsers: Bool) async throws -> ListResponse {
        try await requestAndConvert(to: forAllUsers ? .fetchApplicationKeysForAllUsers : .fetchApplicationKeys, method: .get)
    }

    // MARK: Networking

    private func request<T>(to path: Route, method: HTTPMethod, body: T) throws -> URLRequest where T: Encodable {
        var request = try URLRequest(url: url, path: path, method: method, body: body)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        return request
    }

    private func requestAndConvert<T>(to path: Route, method: HTTPMethod) async throws -> T where T: Decodable {
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

    private func requestAndExpectNoContent<T>(route: Route, body: T) async throws where T: Encodable {
        let request = try request(to: route, method: .post, body: body)
        let code = try await session.perform(request: request).code
        switch code {
        case 204:
            return
        case 400:
            throw OctoprintError.badRequest
        default:
            throw OctoprintError.invalidResponse
        }
    }
}
