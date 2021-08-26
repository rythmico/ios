import XCTest
import FoundationEncore

final class StringEncoreTests: XCTestCase {
    func testInitials() {
        XCTAssertEqual("".initials, "")
        XCTAssertEqual("   ".initials, "")

        XCTAssertEqual("  David     ".initials, "D")
        XCTAssertEqual("David   Roman".initials, "DR")
        XCTAssertEqual("  David    Roman ".initials, "DR")

        XCTAssertEqual("David".initials, "D")
        XCTAssertEqual("David Roman".initials, "DR")
        XCTAssertEqual("David Roman Aguirre".initials, "DRA")
        XCTAssertEqual("David Roman Aguirre Gonzalez".initials, "DRAG")
    }
}
