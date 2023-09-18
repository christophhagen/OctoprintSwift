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
    let state: String

    /// Any error message for the job or connection, only set if there has been an error.
    let error: String?
}

struct EmptyJSON: Codable, Equatable {

    init(from decoder: Decoder) throws {

    }

    func encode(to encoder: Encoder) throws {

    }
}
