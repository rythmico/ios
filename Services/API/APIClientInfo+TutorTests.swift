import XCTest
import FoundationSugar
@testable import Tutor

final class APIClientInfoTutorTests: XCTestCase {
    func test() throws {
        let info = APIClientInfo.current
        XCTAssertEqual(info.keys.count, 3)
        XCTAssertEqual(info["Client-Id"], "com.rythmico.tutor")
        let version = try XCTUnwrap(info["Client-Version"].flatMap(Version.init))
        XCTAssert(version > .null)
        let build = try XCTUnwrap(info["Client-Build"].flatMap(Int.init))
        XCTAssert(build > 0)
    }
}
