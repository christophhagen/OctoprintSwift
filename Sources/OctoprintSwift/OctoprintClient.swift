import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct OctoprintClient {

    public let url: URL

    public var apiKey: String?

    public var session: URLSession

    public let decoder: JSONDecoder

    public init(url: URL, apiKey: String? = nil, session: URLSession = .shared) {
        self.url = url
        self.apiKey = apiKey
        self.session = session
        self.decoder = .init()
    }

    private func request(to path: Route, post: Bool) -> URLRequest {
        var request = URLRequest(url: url.appendingPathComponent(path.rawValue))
        if let apiKey {
            request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        }
        if post {
            request.httpMethod = "POST"
        }
        return request
    }

    func login(passive: Bool = true) async throws {

    }

    // MARK: Authentication

    /**
     Probes for support of the workflow.

     Normally returns an HTTP `204 No Content`, indicating workflow availability. If a different status code is returned (usually an HTTP `404 Not Found`), the plugin is disabled or not installed. Fall back to manual api key exchange.
     */
    public func probeForWorkflowSupport() async throws -> Bool {
        let code = try await makeRequest(to: .probeWorkflowSupport).code
        switch code {
        case 404:
            return false
        case 204:
            return true
        default:
            throw OctoprintError.invalidResponse
        }
    }

    // MARK: Information

    /**
     Retrieve information regarding server and API version.

     Returns a JSON object with three keys, `api` containing the API version, `server` containing the server version, `text` containing the server version including the prefix `OctoPrint` (to determine that this is indeed a genuine OctoPrint instance).
     */
    public func getVersion() async throws -> VersionResponse {
        try await makeRequest(to: .apiVersion)
    }

    /**
     Retrieve information regarding server status.

     Returns a JSON object with two keys, `version` containing the server version and `safemode` containing one of `settings`, `incomplete_startup` or `flag` to indicate the reason the server is running in safe mode, or the boolean value of `false` if it’s not running in safe mode.
     */
    public func getServerInformation() async throws -> ServerInformation {
        try await makeRequest(to: .serverInformation)
    }

    // MARK: Networking

    private func makeRequest<T>(to path: Route, post: Bool = false) async throws -> T where T: Decodable {
        let request = request(to: path, post: post)
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

    private func makeRequest(to path: Route, post: Bool = false) async throws -> (data: Data, code: Int) {
        let request = request(to: path, post: post)
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw OctoprintError.invalidResponse
        }
        return (data, response.statusCode)
    }
}
