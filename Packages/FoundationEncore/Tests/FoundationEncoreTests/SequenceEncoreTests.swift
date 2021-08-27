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

    func testMinByKeyPath() {
        struct Person: Equatable {
            var age: Int
        }
        let a = Person(age: 5)
        let b = Person(age: 3)
        let c = Person(age: 8)
        let d = Person(age: 1)
        XCTAssertEqual([a, b, c, d].min(by: \.age), d)
    }
}
