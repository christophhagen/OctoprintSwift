import Foundation

/**
 The information returned by `GET /api/job`
 */
struct JobStatus: Codable, Equatable {

    /// Information regarding the target of the current print job
    let job: Job

    /// Information regarding the progress of the current print job
    let progress: Progress

    /**
     A textual representation of the current state of the job or connection, e.g. “Operational”, “Printing”, “Pausing”, “Paused”, “Cancelling”, “Error”, “Offline”, “Offline after error”, “Opening serial connection”, … – please note that this list is not exhaustive!
     */
    let state: JobState

    /// Any error message for the job or connection, only set if there has been an error.
    let error: String?
}

struct EmptyJSON: Codable, Equatable {

    init(from decoder: Decoder) throws {

    }

    func encode(to encoder: Encoder) throws {

    }
}

enum JobState {
    case operational
    case printing
    case pausing
    case paused
    case cancelling
    case error
    case offline
    case offlineAfterError
    case openingSerialConnection
    case unknown(String)
}

extension JobState: RawRepresentable {

    init(rawValue: String) {
        switch rawValue {
        case "Operational": self = .operational
        case "Printing": self = .printing
        case "Pausing": self = .pausing
        case "Paused": self = .paused
        case "Cancelling": self = .cancelling
        case "Error": self = .error
        case "Offline": self = .offline
        case "Offline after error": self = .offlineAfterError
        case "Opening serial connection": self = .openingSerialConnection
        default: self = .unknown(rawValue)
        }
    }

    var rawValue: String {
        switch self {
        case .operational: return "Operational"
        case .printing: return "Printing"
        case .pausing: return "Pausing"
        case .paused: return "Paused"
        case .cancelling: return "Cancelling"
        case .error: return "Error"
        case .offline: return "Offline"
        case .offlineAfterError: return "Offline after error"
        case .openingSerialConnection: return "Opening serial connection"
        case .unknown(let string): return string
        }
    }
}

extension JobState: Codable {

}

extension JobState: Equatable {

}
