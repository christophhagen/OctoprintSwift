import Foundation

struct ApplicationKeyCommand {

    let command: Command

    let key: String
}

extension ApplicationKeyCommand {

    enum Command: String {
        case revoke
        case generate
    }
}

extension ApplicationKeyCommand: Encodable {

}

extension ApplicationKeyCommand.Command: Encodable {

}
