import XCTest
import FoundationSugar

final class Bool_SugarTests: XCTestCase {
    func testNot() {
        XCTAssertTrue(false.not)
        XCTAssertFalse(true.not)
    }
}
