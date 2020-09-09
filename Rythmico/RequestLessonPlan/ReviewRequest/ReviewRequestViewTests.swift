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
        Current.lessonPlanRequestService = serviceSpy
        let context = RequestLessonPlanContext()
        return try (
            serviceSpy,
            ReviewRequestView(
                coordinator: XCTUnwrap(Current.ephemeralCoordinator(for: \.lessonPlanRequestService)),
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
