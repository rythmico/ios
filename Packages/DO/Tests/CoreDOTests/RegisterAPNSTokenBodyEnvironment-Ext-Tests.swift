import CoreDO
import XCTest

final class RegisterAPNSTokenBodyEnvironmentTests: XCTestCase {
    func testInitFromMobileProvision() throws {
        XCTAssertEqual(RegisterAPNSTokenBody.Environment(from: .read()), nil)
    }
}
