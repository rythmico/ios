import XCTest
import FoundationEncore

final class StringEncoreTests: XCTestCase {
    func testInitials() {
        XCTAssertEqual("".initials(), "")
        XCTAssertEqual("   ".initials(), "")

        XCTAssertEqual("  David     ".initials(), "D")
        XCTAssertEqual("David   Roman".initials(), "DR")
        XCTAssertEqual("  David    Roman ".initials(), "DR")

        XCTAssertEqual("David".initials(), "D")
        XCTAssertEqual("David Roman".initials(), "DR")
        XCTAssertEqual("David Roman Aguirre".initials(), "DRA")
        XCTAssertEqual("David Roman Aguirre Gonzalez".initials(), "DRAG")
    }

    func testInitials_0() {
        XCTAssertEqual("".initials(0), "")
        XCTAssertEqual("   ".initials(0), "")

        XCTAssertEqual("  David     ".initials(0), "")
        XCTAssertEqual("David   Roman".initials(0), "")
        XCTAssertEqual("  David    Roman ".initials(0), "")

        XCTAssertEqual("David".initials(0), "")
        XCTAssertEqual("David Roman".initials(0), "")
        XCTAssertEqual("David Roman Aguirre".initials(0), "")
        XCTAssertEqual("David Roman Aguirre Gonzalez".initials(0), "")
    }

    func testInitials_1() {
        XCTAssertEqual("".initials(1), "")
        XCTAssertEqual("   ".initials(1), "")

        XCTAssertEqual("  David     ".initials(1), "D")
        XCTAssertEqual("David   Roman".initials(1), "D")
        XCTAssertEqual("  David    Roman ".initials(1), "D")

        XCTAssertEqual("David".initials(1), "D")
        XCTAssertEqual("David Roman".initials(1), "D")
        XCTAssertEqual("David Roman Aguirre".initials(1), "D")
        XCTAssertEqual("David Roman Aguirre Gonzalez".initials(1), "D")
    }

    func testInitials_2() {
        XCTAssertEqual("".initials(2), "")
        XCTAssertEqual("   ".initials(2), "")

        XCTAssertEqual("  David     ".initials(2), "D")
        XCTAssertEqual("David   Roman".initials(2), "DR")
        XCTAssertEqual("  David    Roman ".initials(2), "DR")

        XCTAssertEqual("David".initials(2), "D")
        XCTAssertEqual("David Roman".initials(2), "DR")
        XCTAssertEqual("David Roman Aguirre".initials(2), "DR")
        XCTAssertEqual("David Roman Aguirre Gonzalez".initials(2), "DR")
    }

    func testInitials_5() {
        XCTAssertEqual("".initials(), "")
        XCTAssertEqual("   ".initials(), "")

        XCTAssertEqual("  David     ".initials(), "D")
        XCTAssertEqual("David   Roman".initials(), "DR")
        XCTAssertEqual("  David    Roman ".initials(), "DR")

        XCTAssertEqual("David".initials(), "D")
        XCTAssertEqual("David Roman".initials(), "DR")
        XCTAssertEqual("David Roman Aguirre".initials(), "DRA")
        XCTAssertEqual("David Roman Aguirre Gonzalez".initials(), "DRAG")
    }
}
