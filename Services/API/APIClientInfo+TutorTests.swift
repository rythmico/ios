import XCTest
import CoreDTOEncore

final class APIClientInfoTutorTests: XCTestCase {
    func testBundleClientInfo() throws {
        let info = try XCTUnwrap(Bundle.main.clientInfo)
        XCTAssertEqual(info.id, .tutor)
        XCTAssert(info.version > .null)
        XCTAssert(info.build > 0)
    }
}
