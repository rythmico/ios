import XCTest
import FoundationEncore

final class UUIDEncoreTests: XCTestCase {
    func testZero() {
        XCTAssertEqual(UUID.zero.uuidString, "00000000-0000-0000-0000-000000000000")
        XCTAssertEqual(UUID.zero, UUID.zero)
    }

    func testIncrementing() {
        let uuid = UUID.incrementing
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000000")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000001")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000002")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000003")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000004")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000005")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000006")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000007")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000008")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-000000000009")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-00000000000A")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-00000000000B")
        XCTAssertEqual(uuid().uuidString, "00000000-0000-0000-0000-00000000000C")
        XCTAssertNotEqual(uuid(), uuid())
    }
}
