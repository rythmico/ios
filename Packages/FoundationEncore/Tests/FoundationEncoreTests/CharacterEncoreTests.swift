import XCTest
import FoundationEncore

final class CharacterEncoreTests: XCTestCase {
    func testRepeated() {
        let sut: Character = "a"
        XCTAssertEqual(sut.repeated(), "aa")
        XCTAssertEqual(sut.repeated(1), "a")
        XCTAssertEqual(sut.repeated(2), "aa")
        XCTAssertEqual(sut.repeated(3), "aaa")
        XCTAssertEqual(sut.repeated(4), "aaaa")
        XCTAssertEqual(sut.repeated(5), "aaaaa")
    }

    func testRepeatedEmoji() {
        let sut: Character = "🔥"
        XCTAssertEqual(sut.repeated(), "🔥🔥")
        XCTAssertEqual(sut.repeated(1), "🔥")
        XCTAssertEqual(sut.repeated(2), "🔥🔥")
        XCTAssertEqual(sut.repeated(3), "🔥🔥🔥")
        XCTAssertEqual(sut.repeated(4), "🔥🔥🔥🔥")
        XCTAssertEqual(sut.repeated(5), "🔥🔥🔥🔥🔥")
    }
}
