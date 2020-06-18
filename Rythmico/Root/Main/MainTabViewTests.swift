import XCTest
@testable import Rythmico

final class MainTabViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testPushNotificationRegistrationOnAppear() throws {
        Current.deviceTokenProvider = DeviceTokenProviderStub(result: .success("TOKEN"))

        let spy = DeviceRegisterServiceSpy()
        Current.deviceRegisterService = spy

        let view = try XCTUnwrap(MainTabView())

        XCTAssertView(view) { view in
            XCTAssertEqual(spy.registerCount, 1)
        }
    }

    func testPresentRequestLessonFlow() throws {
        let view = try XCTUnwrap(MainTabView())

        XCTAssertView(view) { view in
            XCTAssertNil(view.lessonRequestView)
            view.presentRequestLessonFlow()
            XCTAssertNotNil(view.lessonRequestView)
        }
    }
}
