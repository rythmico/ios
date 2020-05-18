import XCTest
@testable import Rythmico

final class ReviewRequestViewTests: XCTestCase {
    var reviewRequestView: (RequestLessonPlanCoordinatorSpy, ReviewRequestView) {
        let coordinator = RequestLessonPlanCoordinatorSpy()
        let context = RequestLessonPlanContext()
        return (
            coordinator,
            ReviewRequestView(
                coordinator: coordinator,
                context: context,
                instrument: .drumsStub,
                student: .davidStub,
                address: .stub,
                schedule: .stub,
                privateNote: ""
            )
        )
    }

    func testCoordinatorValues() {
        let (coordinator, view) = reviewRequestView

        XCTAssertView(view) { view in
            XCTAssertEqual(coordinator.requestCount, 0)
            XCTAssertNil(coordinator.latestRequestBody)
            view.submitRequest()
            XCTAssertEqual(coordinator.requestCount, 1)
            XCTAssertEqual(coordinator.latestRequestBody?.instrument, .drumsStub)
            XCTAssertEqual(coordinator.latestRequestBody?.student, .davidStub)
            XCTAssertEqual(coordinator.latestRequestBody?.address, .stub)
            XCTAssertEqual(coordinator.latestRequestBody?.schedule, .stub)
            XCTAssertEqual(coordinator.latestRequestBody?.privateNote, "")
        }
    }
}
