import XCTest
@testable import Rythmico
import ViewInspector

extension ReviewRequestView: Inspectable {}

final class ReviewRequestViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func reviewRequestView() throws -> (APIServiceSpy<CreateLessonPlanRequest>, ReviewRequestView) {
        let serviceSpy = APIServiceSpy<CreateLessonPlanRequest>()
        Current.stubAPIEndpoint(for: \.lessonPlanRequestCoordinator, service: serviceSpy)
        let context = RequestLessonPlanContext()
        return (
            serviceSpy,
            ReviewRequestView(
                coordinator: Current.lessonPlanRequestCoordinator(),
                context: context,
                instrument: .drums,
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
            XCTAssertNil(serviceSpy.latestRequest?.properties)
            view.submitRequest()
            XCTAssertEqual(serviceSpy.sendCount, 1)
            XCTAssertEqual(serviceSpy.latestRequest?.instrument, .drums)
            XCTAssertEqual(serviceSpy.latestRequest?.student, .davidStub)
            XCTAssertEqual(serviceSpy.latestRequest?.address, .stub)
            XCTAssertEqual(serviceSpy.latestRequest?.schedule, .stub)
            XCTAssertEqual(serviceSpy.latestRequest?.privateNote, "")
        }
    }
}
