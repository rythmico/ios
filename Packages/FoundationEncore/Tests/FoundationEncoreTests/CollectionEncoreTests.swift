import XCTest
import FoundationEncore

final class CollectionEncoreTests: XCTestCase {
    func testNilIfEmpty() {
        XCTAssertEqual([Int]().nilIfEmpty, nil)
        XCTAssertEqual([1].nilIfEmpty, [1])
        XCTAssertEqual([1, 2].nilIfEmpty, [1, 2])
        XCTAssertEqual([1, 2, 3].nilIfEmpty, [1, 2, 3])
    }

    func testSafeSubscript() {
        let emptyArray: [Int] = []
        XCTAssertEqual(emptyArray[safe: -3], nil)
        XCTAssertEqual(emptyArray[safe: -2], nil)
        XCTAssertEqual(emptyArray[safe: -1], nil)
        XCTAssertEqual(emptyArray[safe: 0], nil)
        XCTAssertEqual(emptyArray[safe: 1], nil)
        XCTAssertEqual(emptyArray[safe: 2], nil)
        XCTAssertEqual(emptyArray[safe: 3], nil)

        let array: [Int] = [1, 2, 3]
        XCTAssertEqual(array[safe: -3], nil)
        XCTAssertEqual(array[safe: -2], nil)
        XCTAssertEqual(array[safe: -1], nil)
        XCTAssertEqual(array[safe: 0], 1)
        XCTAssertEqual(array[safe: 1], 2)
        XCTAssertEqual(array[safe: 2], 3)
        XCTAssertEqual(array[safe: 3], nil)
    }

    func testAppending() {
        XCTAssertEqual([1, 2, 3].appending(4), [1, 2, 3, 4])
        XCTAssertEqual([1, 2, 3] + 4, [1, 2, 3, 4])
    }

    func testRemoveAllOf() {
        var array = [3, 2, 1, 3]
        array.removeAll(of: 3)
        XCTAssertEqual(array, [2, 1])
    }

    func testRemovingAllOf() {
        XCTAssertEqual([3].removingAll(of: 3), [])
        XCTAssertEqual([1, 3].removingAll(of: 3), [1])
        XCTAssertEqual([2, 1, 3].removingAll(of: 3), [2, 1])
        XCTAssertEqual([3, 2, 1, 3].removingAll(of: 3), [2, 1])
    }
}
