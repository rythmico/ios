import XCTest
@testable import Tutor

final class APIClientInfoTutorTests: XCTestCase {
    func test() {
        let info = APIClientInfo.current
        XCTAssertEqual(info.keys.count, 3)
        XCTAssertEqual(info["Client-Id"], "com.rythmico.tutor")
        XCTAssertEqual(info["Client-Version"], "1.0.0")
        XCTAssertNotNil(info["Client-Build"].flatMap(Int.init))
    }
}
