import Foundation

struct DecisionRequest {

    /// `true` if the access request it to be granted, `false` otherwise
    let decision: Bool
}

extension DecisionRequest: Encodable {
    
}
