import Foundation

struct Job {

    /**
     File information (abridged)
     The file that is the target of the current print job.
     */
    let file: File

    let averagePrintTime: Float?

    /// The estimated print time for the file, in seconds.
    let estimatedPrintTime: Float?

    /// The print time of the last print of the file, in seconds.
    let lastPrintTime: Float?

    /// Information regarding the estimated filament usage of the print job
    let filament: Filament?

    let user: EmptyJSON?
}

extension Job: Codable {

}

extension Job: Equatable {

}
