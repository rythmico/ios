import XCTest
@testable import Rythmico

final class ReviewRequestViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func reviewRequestView() throws -> (LessonPlanRequestServiceSpy, ReviewRequestView) {
        let serviceSpy = LessonPlanRequestServiceSpy()
        Current.lessonPlanRequestService = serviceSpy
        let context = RequestLessonPlanContext()
        return try (
            serviceSpy,
            ReviewRequestView(
                coordinator: XCTUnwrap(Current.lessonPlanRequestCoordinator()),
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
            XCTAssertEqual(serviceSpy.requestCount, 0)
            XCTAssertNil(serviceSpy.latestRequestBody)
            view.submitRequest()
            XCTAssertEqual(serviceSpy.requestCount, 1)
            XCTAssertEqual(serviceSpy.latestRequestBody?.instrument, .drums)
            XCTAssertEqual(serviceSpy.latestRequestBody?.student, .davidStub)
            XCTAssertEqual(serviceSpy.latestRequestBody?.address, .stub)
            XCTAssertEqual(serviceSpy.latestRequestBody?.schedule, .stub)
            XCTAssertEqual(serviceSpy.latestRequestBody?.privateNote, "")
        }
    }
}
