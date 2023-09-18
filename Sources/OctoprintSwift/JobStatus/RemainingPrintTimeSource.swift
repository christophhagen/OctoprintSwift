import Foundation

enum RemainingPrintTimeSource: String {
    
    /// based on an linear approximation of the progress in file in bytes vs time
    case linear
    /// based on an analysis of the file
    case analysis
    /// calculated estimate after stabilization of linear estimation
    case estimate
    /// based on the average total from past prints of the same model against the same printer profile
    case average
    /// mixture of estimate and analysis
    case mixedAnalysis = "mixed-analysis"
    /// mixture of estimate and average
    case mixedAverage = "mixed-average"
}

extension RemainingPrintTimeSource: Codable {

}

extension RemainingPrintTimeSource: Equatable {

}
