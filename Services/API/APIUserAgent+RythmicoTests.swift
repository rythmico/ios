import XCTest
@testable import Rythmico

final class APIUserAgentRythmicoTests: XCTestCase {
    func test() {
        XCTAssert(APIUserAgent.current?.hasPrefix("com.rythmico.student") == true)
    }
}
