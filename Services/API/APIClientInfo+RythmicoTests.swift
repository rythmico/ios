import XCTest
import CoreDTOEncore

final class APIClientInfoRythmicoTests: XCTestCase {
    func testBundleClientInfo() throws {
        let info = try XCTUnwrap(Bundle.main.clientInfo)
        XCTAssertEqual(info.id, .student)
        XCTAssert(info.version > .null)
        XCTAssert(info.build > 0)
    }
}
