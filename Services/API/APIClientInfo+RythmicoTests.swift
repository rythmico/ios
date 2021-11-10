import CoreDO
import XCTest

final class APIClientInfoRythmicoTests: XCTestCase {
    func testStudentClientInfo() throws {
        let info = try XCTUnwrap(APIClientInfo.current)
        XCTAssertEqual(info.id, .student)
        XCTAssert(info.version > .null)
        XCTAssert(info.build > 0)
        XCTAssert(info.device.isBlank.not)
        XCTAssert(info.os.isBlank.not)
    }
}
