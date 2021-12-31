import CoreDO
import XCTest

final class APIClientInfoTutorTests: XCTestCase {
    func testTutorClientInfo() throws {
        let info = try XCTUnwrap(APIClientInfo.current)
        XCTAssertEqual(info.id, .tutor)
        XCTAssert(info.version > .null)
        XCTAssert(info.build > 0)
        XCTAssert(info.device.isBlank.not)
        XCTAssert(info.os.isBlank.not)
    }
}
