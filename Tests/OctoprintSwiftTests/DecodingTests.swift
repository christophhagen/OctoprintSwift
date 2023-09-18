import XCTest
@testable import OctoprintSwift

final class DecodingTests: XCTestCase {

    func testVersionDecoding() throws {

        let response =
        """
        {
          "api": "0.1",
          "server": "1.3.10",
          "text": "OctoPrint 1.3.10"
        }
        """

        let data = response.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(VersionResponse.self, from: data)

        let expected = VersionResponse(
            api: .init(major: 0, minor: 1, patch: nil),
            server: .init(major: 1, minor: 3, patch: 10))

        XCTAssertEqual(decoded, expected)
    }

    func testServerInfoDecoding() throws {

        let response =
        """
        {
          "version": "1.5.0",
          "safemode": "incomplete_startup"
        }
        """

        let data = response.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(ServerInformation.self, from: data)

        let expected = ServerInformation(
            version: .init(major: 1, minor: 5, patch: 0),
            safeMode: .incompleteStartup)

        XCTAssertEqual(decoded, expected)
    }
}
