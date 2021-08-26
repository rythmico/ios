import XCTest
import FoundationEncore

final class BundleEncoreTests: XCTestCase {
    func test() {
        XCTAssertEqual(Bundle.main.id?.rawValue, "com.apple.dt.xctest.tool")
        XCTAssertEqual(Bundle.main.version, nil)
        XCTAssertEqual(Bundle.main.build?.rawValue, 18143)
    }
}
