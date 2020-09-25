import XCTest
@testable import Rythmico
import ViewInspector

extension MainView: Inspectable {}

final class MainViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
        Current.lessonPlanFetchingService = APIServiceStub(result: .success([.pendingJackGuitarPlanStub]))
    }

    func testDeviceRegistrationOnAppear() throws {
        Current.deviceTokenProvider = DeviceTokenProviderStub(result: .success("TOKEN"))

        let spy = APIServiceSpy<AddDeviceRequest>()
        Current.deviceRegisterService = spy

        let view = try XCTUnwrap(MainView())

        XCTAssertView(view) { view in
            XCTAssertEqual(spy.sendCount, 1)
        }
    }

    func testPresentRequestLessonFlow() throws {
        let view = try XCTUnwrap(MainView())

        XCTAssertView(view) { view in
            XCTAssertFalse(view.isLessonRequestViewPresented)
            view.presentRequestLessonFlow()
            XCTAssertTrue(view.isLessonRequestViewPresented)
        }
    }

    func testAutoPresentRequestLessonFlow() throws {
        Current.lessonPlanFetchingService = APIServiceStub(result: .success([]))

        let view = try XCTUnwrap(MainView())

        XCTAssertView(view) { view in
            XCTAssertTrue(view.isLessonRequestViewPresented)
        }
    }
}
