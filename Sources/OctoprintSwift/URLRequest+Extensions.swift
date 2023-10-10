import Foundation

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {

    mutating func setBody<T>(_ jsonPayload: T) throws where T: Encodable {
        httpBody = try JSONEncoder().encode(jsonPayload)
    }

    init(url: URL, path: Route, method: HTTPMethod = .post) {
        self.init(url: url.appendingPathComponent(path.rawValue))
        self.httpMethod = method.rawValue
    }

    init<T>(url: URL, path: Route, method: HTTPMethod = .post, body: T) throws where T: Encodable {
        self.init(url: url.appendingPathComponent(path.rawValue))
        self.httpMethod = method.rawValue
        httpBody = try JSONEncoder().encode(body)
    }
}
