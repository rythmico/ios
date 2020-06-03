import XCTest
@testable import Rythmico

final class ReviewRequestViewTests: XCTestCase {
    var reviewRequestView: (LessonPlanRequestCoordinatorSpy, ReviewRequestView) {
        let coordinator = LessonPlanRequestCoordinatorSpy()
        let context = RequestLessonPlanContext()
        return (
            coordinator,
            ReviewRequestView(
                coordinator: coordinator,
                context: context,
                instrument: .drums,
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
            XCTAssertEqual(coordinator.latestRequestBody?.instrument, .drums)
            XCTAssertEqual(coordinator.latestRequestBody?.student, .davidStub)
            XCTAssertEqual(coordinator.latestRequestBody?.address, .stub)
            XCTAssertEqual(coordinator.latestRequestBody?.schedule, .stub)
            XCTAssertEqual(coordinator.latestRequestBody?.privateNote, "")
        }
    }
}
