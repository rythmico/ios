import XCTest
import FoundationEncore

final class UUIDEncoreTests: XCTestCase {
    func testZero() {
        XCTAssertEqual(UUID.zero.uuidString, "00000000-0000-0000-0000-000000000000")
        XCTAssertEqual(UUID.zero, UUID.zero)
    }
}
