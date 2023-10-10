import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking

extension URLSession {

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let result: Result<(response: URLResponse, data: Data), Error> = await withCheckedContinuation { continuation in
            let task = dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(returning: .failure(error))
                } else {
                    continuation.resume(returning: .success((response!, data!)))
                }
            }
            task.resume()
        }
        switch result {
        case .failure(let error):
            throw error
        case .success(let result):
            return (result.data, result.response)
        }
    }
}

#endif

extension URLSession {
    
    func performRequest<T>(to url: URL, path: Route, method: HTTPMethod = .post, body: T) async throws -> (data: Data, code: Int) where T: Encodable {
        var request = URLRequest(url: url, path: path, method: method)
        try request.setBody(body)
        return try await perform(request: request)
    }

    private func performRequest(to url: URL, path: Route, method: HTTPMethod = .post) async throws -> (data: Data, code: Int) {
        let request = URLRequest(url: url, path: path, method: method)
        return try await perform(request: request)
    }

    func perform(request: URLRequest) async throws -> (data: Data, code: Int) {
        let (data, response) = try await data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw OctoprintError.invalidResponse
        }
        return (data, response.statusCode)
    }
}
