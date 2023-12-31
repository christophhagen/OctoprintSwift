import Foundation

/**
 Instructs OctoPrint to connect or, if already connected, reconnect to the printer.
 */
struct Connect {

    let command: ConnectionCommand

    /**
     Specific port to connect to. If not set the current `portPreference` will be used, or if no preference is available auto detection will be attempted.
     */
    let port: String?

    /**
     Specific baudrate to connect with. If not set the current `baudratePreference` will be used, or if no preference is available auto detection will be attempted.
     */
    let baudrate: Int?

    /**
     Specific printer profile to use for connection. If not set the current default printer profile will be used.
     */
    let printerProfile: String?

    /**
     Whether to save the request’s `port` and `baudrate` settings as new preferences. Defaults to `false` if not set.
     */
    let save: Bool?

    /**
     Whether to automatically connect to the printer on OctoPrint’s startup in the future. If not set no changes will be made to the current configuration.
     */
    let autoconnect: Bool?

    init(command: ConnectionCommand, port: String? = nil, baudrate: Int? = nil, printerProfile: String? = nil, save: Bool? = nil, autoconnect: Bool? = nil) {
        self.command = command
        self.port = port
        self.baudrate = baudrate
        self.printerProfile = printerProfile
        self.save = save
        self.autoconnect = autoconnect
    }
}

extension Connect: Encodable {

}
