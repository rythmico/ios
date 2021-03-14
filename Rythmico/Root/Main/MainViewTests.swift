import XCTest
@testable import Rythmico
import ViewInspector

extension MainView: Inspectable {}

final class MainViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
        Current.stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success([.pendingJackGuitarPlanStub]))
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
            XCTAssertEqual(Current.state.lessonsContext, .none)
            view.presentRequestLessonFlow()
            XCTAssertEqual(Current.state.lessonsContext, .requestingLessonPlan)
        }
    }

    func testAutoPresentRequestLessonFlow() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success([]))

        let view = try XCTUnwrap(MainView())

        XCTAssertView(view) { view in
            XCTAssertEqual(Current.state.lessonsContext, .requestingLessonPlan)
        }
    }
}
