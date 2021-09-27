import XCTest
import CoreDTOEncore

final class APIClientInfoTutorTests: XCTestCase {
    func testBundleClientInfo() throws {
        let info = try XCTUnwrap(Bundle.main.clientInfo)
        XCTAssertEqual(info.id, "com.rythmico.tutor")
        XCTAssert(info.version > .null)
        XCTAssert(info.build > 0)
    }
}
