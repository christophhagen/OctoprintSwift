import Foundation

struct KeyResponse {

    let apiKey: String
}

extension KeyResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
