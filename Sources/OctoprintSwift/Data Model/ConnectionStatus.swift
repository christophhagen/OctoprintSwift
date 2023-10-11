import Foundation

public struct ConnectionStatus {

    public let current: Current

    public let options: Options
}

extension ConnectionStatus: Codable {

}

extension ConnectionStatus {

    public struct Current {

        public let state: String

        public let port: String

        public let baudrate: Int

        public let printerProfile: String
    }
}

extension ConnectionStatus.Current: Codable {

}

extension ConnectionStatus {

    public struct Options {
        public let ports: [String]
        public let baudrates: [Int]
        public let printerProfiles: [PrinterProfile]
        public let portPreference: String
        public let baudratePreference: Int
        public let printerProfilePreference: String
        public let autoconnect: Bool
    }
}

extension ConnectionStatus.Options: Codable {

}

extension ConnectionStatus.Options {

    public struct PrinterProfile {
        public let name: String
        public let id: String
    }
}

extension ConnectionStatus.Options.PrinterProfile: Codable {

}
