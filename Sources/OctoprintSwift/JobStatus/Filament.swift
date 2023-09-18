import Foundation

struct Filament {

    /// Length of filament used, in mm
    let length: Float

    /// Volume of filament used, in cm³
    let volume: Float
}

extension Filament: Equatable {

}

extension Filament: Codable {

}
