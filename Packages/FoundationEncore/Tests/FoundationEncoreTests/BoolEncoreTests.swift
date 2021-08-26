import XCTest
import FoundationEncore

final class BoolEncoreTests: XCTestCase {
    func testNot() {
        XCTAssertTrue(false.not)
        XCTAssertFalse(true.not)
    }
}
