import XCTest
@testable import Tutor

final class APIUserAgentTutorTests: XCTestCase {
    func test() {
        XCTAssert(APIUserAgent.current?.hasPrefix("com.rythmico.tutor") == true)
    }
}
