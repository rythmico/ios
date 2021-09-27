import XCTest
import CoreDTOEncore

final class APIClientInfoRythmicoTests: XCTestCase {
    func testBundleClientInfo() throws {
        let info = try XCTUnwrap(Bundle.main.clientInfo)
        XCTAssertEqual(info.id, "com.rythmico.student")
        XCTAssert(info.version > .null)
        XCTAssert(info.build > 0)
    }
}
