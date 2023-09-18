import Foundation

struct Progress {

    /// Percentage of completion of the current print job
    let completion: Float?

    /// Current position in the file being printed, in bytes from the beginning
    let filepos: Int?

    /// Time already spent printing, in seconds
    let printTime: Int?

    /// Estimate of time left to print, in seconds
    let printTimeLeft: Int?

    let printTimeLeftOrigin: RemainingPrintTimeSource?
}

extension Progress: Codable {

}

extension Progress: Equatable {

}
