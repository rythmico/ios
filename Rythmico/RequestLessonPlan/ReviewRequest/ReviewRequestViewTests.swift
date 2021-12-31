import XCTest
@testable import Rythmico
import ViewInspector

extension ReviewRequestView: Inspectable {}

final class ReviewRequestViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func reviewRequestView() throws -> (APIServiceSpy<CreateLessonPlanRequestRequest>, ReviewRequestView) {
        let serviceSpy = APIServiceSpy<CreateLessonPlanRequestRequest>()
        Current.stubAPIEndpoint(for: \.lessonPlanRequestCreationCoordinator, service: serviceSpy)
        let flow = RequestLessonPlanFlow()
        return (
            serviceSpy,
            ReviewRequestView(
                coordinator: Current.lessonPlanRequestCreationCoordinator(),
                flow: flow,
                instrument: .stub(.drums),
                student: .davidStub,
                address: .stub,
                schedule: .stub,
                privateNote: ""
            )
        )
    }

    func testCoordinatorValues() throws {
        let (serviceSpy, view) = try reviewRequestView()

        XCTAssertView(view) { view in
            XCTAssertEqual(serviceSpy.sendCount, 0)
            XCTAssertNil(serviceSpy.latestRequest)
            view.submitRequest()
            XCTAssertEqual(serviceSpy.sendCount, 1)
            XCTAssertEqual(serviceSpy.latestRequest?.body.instrument, .known(.drums))
            XCTAssertEqual(serviceSpy.latestRequest?.body.student, .davidStub)
            XCTAssertEqual(serviceSpy.latestRequest?.body.address, .stub)
            XCTAssertEqual(serviceSpy.latestRequest?.body.schedule, .stub)
            XCTAssertEqual(serviceSpy.latestRequest?.body.privateNote, "")
        }
    }
}
