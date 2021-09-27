import CoreDTOEncore
import XCTest

final class APIClientInfoEncoreTests: XCTestCase {
    func testEncodeAsHTTPHeaders() throws {
        let sut = APIClientInfo(
            id: "com.rythmico.test-suite",
            version: Version(1, 5, 0),
            build: 123
        )

        XCTAssertEqual(sut.encodeAsHTTPHeaders(), [
            "Client-ID": "com.rythmico.test-suite",
            "Client-Version": "1.5.0",
            "Client-Build": "123",
        ])
    }
}
