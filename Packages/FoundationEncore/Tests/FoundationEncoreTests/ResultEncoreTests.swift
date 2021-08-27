import XCTest
import FoundationEncore

final class ResultEncoreTests: XCTestCase {
    func testInitWithValueAndError() {
        typealias Result = Swift.Result<Int, String>
        XCTAssertEqual(Result(value: 3, error: "Error"), .success(3))
        XCTAssertEqual(Result(value: 3, error: nil), .success(3))
        XCTAssertEqual(Result(value: nil, error: "Error"), .failure("Error"))
        XCTAssertNil(Result(value: nil, error: nil))
    }
}
