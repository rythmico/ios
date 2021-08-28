import XCTest
import FoundationEncore

final class SequenceEncoreTests: XCTestCase {
    func testCountWhere() {
        XCTAssertEqual([3, 2, 1, 3].count(where: { $0 == 0 }), 0)
        XCTAssertEqual([3, 2, 1, 3].count(where: { $0 == 1 }), 1)
        XCTAssertEqual([3, 2, 1, 3].count(where: { $0 == 2 }), 1)
        XCTAssertEqual([3, 2, 1, 3].count(where: { $0 == 3 }), 2)
        XCTAssertEqual([3, 2, 1, 3].count(where: { $0 == 4 }), 0)
    }

    func testSortedByKeyPath() {
        struct Person: Equatable {
            var age: Int
        }
        let a = Person(age: 5)
        let b = Person(age: 3)
        let c = Person(age: 8)
        let d = Person(age: 1)
        XCTAssertEqual([a, b, c, d].sorted(by: \.age), [d, b, a, c])
        XCTAssertEqual([a, b, c, d].sorted(by: \.age, <), [d, b, a, c])
        XCTAssertEqual([a, b, c, d].sorted(by: \.age, >), [c, a, b, d])
    }

    func testMinAndMaxByKeyPath() throws {
        struct Person: Equatable {
            var age: Int
        }
        let a = Person(age: 5)
        let b = Person(age: 3)
        let c = Person(age: 8)
        let d = Person(age: 1)
        XCTAssertEqual([a, b, c, d].min(by: \.age), d)
        XCTAssertEqual([a, b, c, d].min(by: \.age, <), d)
        XCTAssertEqual([a, b, c, d].min(by: \.age, >), c)

        XCTAssertEqual([a, b, c, d].max(by: \.age), c)
        XCTAssertEqual([a, b, c, d].max(by: \.age, <), c)
        XCTAssertEqual([a, b, c, d].max(by: \.age, >), d)

        XCTAssert(try XCTUnwrap([a, b, c, d].minAndMax(by: \.age)) == (d, c))
        XCTAssert(try XCTUnwrap([a, b, c, d].minAndMax(by: \.age, <)) == (d, c))
        XCTAssert(try XCTUnwrap([a, b, c, d].minAndMax(by: \.age, >)) == (c, d))
    }
}
