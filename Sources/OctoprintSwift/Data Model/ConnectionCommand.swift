import Foundation

enum ConnectionCommand: String {

    case connect
    case disconnect
    case fakeAck = "fake_ack"
}

extension ConnectionCommand: Encodable {
    
}
