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
        let spy = APIServiceSpy<AddDeviceRequest>()
        Current.deviceRegisterCoordinator = DeviceRegisterCoordinator(
            deviceTokenProvider: DeviceTokenProviderStub(result: .success("TOKEN")),
            apiCoordinator: Current.coordinator(for: spy)
        )

        let view = MainView()
        XCTAssertView(view) { view in
            XCTAssertEqual(spy.sendCount, 1)
        }
    }

    func testPresentRequestLessonFlow() throws {
        let view = MainView()
        XCTAssertView(view) { view in
            XCTAssertEqual(Current.state.lessonsContext, .none)
            view.presentRequestLessonFlow()
            XCTAssertEqual(Current.state.lessonsContext, .requestingLessonPlan)
        }
    }

    func testAutoPresentRequestLessonFlow() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success([]))

        let view = MainView()
        XCTAssertView(view) { view in
            XCTAssertEqual(Current.state.lessonsContext, .requestingLessonPlan)
        }
    }
}
