import CoreDTOEncore
import XCTest

final class APIClientInfoTests: XCTestCase {
    struct BundleMock: BundleProtocol {
        let infoDictionary: [String: Any]? = [
            kCFBundleIdentifierKey as String: "com.rythmico.student",
            kCFBundleShortVersionKey as String: "1.0.0",
            kCFBundleVersionKey as String: "123",
        ]
    }

    struct UIDeviceMock: UIDeviceProtocol {
        let systemName: String = "iOS"
        let systemVersion: String = "15.0"
    }

    func testInitWithBundleAndDevice() throws {
        let info = try XCTUnwrap(APIClientInfo(bundle: BundleMock(), device: UIDeviceMock()))
        XCTAssertEqual(info.id, .student)
        XCTAssertEqual(info.version, Version(1, 0, 0))
        XCTAssertEqual(info.build, 123)

        let deviceModel = UIDevice.current.model
        XCTAssert(info.device.isEmpty.not)
        XCTAssert(info.device.count > deviceModel.count)
        XCTAssert(info.device.hasPrefix(deviceModel) == true)

        XCTAssertEqual(info.os, "iOS 15.0")
    }
}
