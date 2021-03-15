import XCTest
import FoundationSugar

final class Array_SugarTests: XCTestCase {
    func testBuilder() {
        let sut: [Any] = Array.build {
            if true {
                1
            }
            false
            if false {
                "c"
            } else if false {
                4
            } else {
                "e"
            }
            for i in 0..<3 {
                "\(i)"
            }
            "1"
        }
        XCTAssertEqual(sut.count, 7)
        XCTAssertEqual(sut[0] as? Int, 1)
        XCTAssertEqual(sut[1] as? Bool, false)
        XCTAssertEqual(sut[2] as? String, "e")
        XCTAssertEqual(sut[3] as? String, "0")
        XCTAssertEqual(sut[4] as? String, "1")
        XCTAssertEqual(sut[5] as? String, "2")
        XCTAssertEqual(sut[6] as? String, "1")
    }

    func testBuilderWithOptionals() {
        let sut: [Int] = Array.build {
            420
            if false {
                120
            }
            69
        }
        XCTAssertEqual(sut.count, 2)
        XCTAssertEqual(sut[0], 420)
        XCTAssertEqual(sut[1], 69)
    }
}
