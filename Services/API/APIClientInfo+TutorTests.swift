import XCTest
import FoundationSugar
@testable import Tutor

final class APIClientInfoTutorTests: XCTestCase {
    func test() {
        let info = APIClientInfo.current
        XCTAssertEqual(info.keys.count, 3)
        XCTAssertEqual(info["Client-Id"], "com.rythmico.tutor")
        XCTAssertNotNil(info["Client-Version"].flatMap(Version.init))
        XCTAssertNotNil(info["Client-Build"].flatMap(Int.init))
    }
}
