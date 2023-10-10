import Foundation

public actor RegistrationClient {

    public let url: URL

    public let session: URLSession

    public let decoder = JSONDecoder()

    public init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    /**
     Probes for support of the workflow.

     Indicates workflow availability. A return value other than `true` indicates that the plugin is disabled or not installed. Fall back to manual api key exchange.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/bundledplugins/appkeys.html#probe-for-workflow-support)
     */
    public func probeForWorkflowSupport() async throws -> Bool {
        let request = URLRequest(url: url, path: .probeWorkflowSupport, method: .get)
        let code = try await session.perform(request: request).code
        switch code {
        case 404:
            return false
        case 204:
            return true
        default:
            throw OctoprintError.invalidResponse
        }
    }

    /**
     Starts the authorization process.

     The `app` parameter should be a human readable identifier to use for the application requesting access. It will be displayed to the user. Internally it will be used case insensitively, so `My App` and `my APP` are considered the same application identifiers.

     The optional `user` parameter should be used to limit the authorization process to a specified user. If the parameter is left unset, any user will be able to complete the authorization process and grant access to the app with their account. E.g. if a user `me` starts the process in an app, the app should request that name from the user and use it in the `user` parameter. OctoPrint will then only display the authorization request on browsers the user `me` is logged in on.

     Use the returned object to continuously query the ``isAuthorizationGranted(for:)`` function, until the user accepts or denies the request.
     At the same time, show the returned ``authenticationDialogUrl`` to guide the user to log in through a browser and handle the request.

     - Parameter app: application identifier to use for the request, case insensitive
     - Parameter user: optional user id to restrict the decision to the specified user
     - Returns: An `AuthorizationResponse` and the endpoint to poll for a decision
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/bundledplugins/appkeys.html#start-authorization-process)
     */
    public func requestApplicationKey(applicationId: String, user: String?) async throws -> PendingAuthorizationDecision {
        let body = AuthorizationRequest(app: applicationId, user: user)
        let request = try URLRequest(url: url, path: .requestAppKey, body: body)
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OctoprintError.invalidResponse
        }
        guard httpResponse.statusCode == 201 else {
            throw OctoprintError.invalidResponse
        }
        guard let endPoint = httpResponse.value(forHTTPHeaderField: "Location") else {
            throw OctoprintError.invalidResponse
        }
        do {
            let authResponse = try decoder.decode(AuthorizationResponse.self, from: data)
            return .init(endpoint: endPoint, response: authResponse)
        } catch {
            throw OctoprintError.invalidResponse
        }
    }

    /**
     Poll for the result of an authorization request.

     - Note: The request will be considered stale and deleted internally if the polling endpoint for it isn’t called for more than 5s.
     - Returns: `nil`, if no decision has been made yet. `true`, if access has been granted, and `false` if the request has been denied or timed out.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/bundledplugins/appkeys.html#poll-for-decision-on-existing-request)
     */
    public func isAuthorizationGranted(for pendingDecision: PendingAuthorizationDecision) async throws -> AuthorizationDecision? {
        let token = pendingDecision.response.applicationToken
        let request = URLRequest(url: url, path: .pollAppKeyRequestDecision(appToken: token), method: .get)
        let response = try await session.perform(request: request)
        switch response.code {
        case 404:
            return .denied
        case 202:
            return nil
        case 200:
            break
        default:
            throw OctoprintError.invalidResponse
        }
        do {
            let keyResponse = try decoder.decode(KeyResponse.self, from: response.data)
            return .granted(apiKey: keyResponse.apiKey)
        } catch {
            throw OctoprintError.invalidResponse
        }
    }

    /**
     Decide on the authorization request.

     - Parameter allow: boolean value to indicate whether to confirm (`true`) or deny (`false`) access
     - Parameter userToken: The authentication token of the user responding to the request.
     - SeeAlso: [API function description](https://docs.octoprint.org/en/master/bundledplugins/appkeys.html#decide-on-existing-request)
     */
    public func decideExistingAppKeyRequest(userToken: String, allow: Bool) async throws {
        let decision = DecisionRequest(decision: allow)
        let request = try URLRequest(url: url, path: .decideExistingRequest(userToken: userToken), body: decision)
        let code = try await session.perform(request: request).code
        guard code == 204 else {
            throw OctoprintError.invalidResponse
        }
    }
}
