import XCTest
@testable import Rythmico

final class APIClientInfoRythmicoTests: XCTestCase {
    func test() {
        let info = APIClientInfo.current
        XCTAssertEqual(info.keys.count, 3)
        XCTAssertEqual(info["Client-Id"], "com.rythmico.student")
        XCTAssertEqual(info["Client-Version"], "1.2.0")
        XCTAssertNotNil(info["Client-Build"].flatMap(Int.init))
    }
}
