import XCTest
@testable import Rythmico
import ViewInspector

extension SchedulingView: Inspectable {}

final class SchedulingViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
    }

    var schedulingView: (RequestLessonPlanContext, SchedulingView.ViewState, SchedulingView) {
        let context = RequestLessonPlanContext()
        let state = SchedulingView.ViewState()
        return (
            context,
            state,
            SchedulingView(
                state: state,
                instrument: .guitar,
                context: context
            )
        )
    }

    func testInitialValues() {
        let (context, state, view) = schedulingView

        XCTAssertView(view) { view in
            XCTAssertNil(context.schedule)

            XCTAssertEqual(
                view.subtitle.string,
                "Enter when you want the Guitar lessons to commence and for how long"
            )

            XCTAssertFalse(state.hasFocusedDate)
            XCTAssertFalse(state.hasFocusedTime)

            XCTAssertNil(state.startDate)
            XCTAssertNil(state.duration)

            XCTAssertEqual(view.editingFocus, .none)

            XCTAssertNil(view.startDateText)
            XCTAssertNil(view.startTimeText)
            XCTAssertNil(view.durationText)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingStartDate() {
        let expectation = self.expectation(description: "")
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            view.beginEditingStartDate()

            DispatchQueue.main.async {
                XCTAssertNotNil(state.startDate)
                XCTAssertNil(state.duration)
                XCTAssertTrue(state.hasFocusedDate)
                XCTAssertFalse(state.hasFocusedTime)

                XCTAssertEqual(view.editingFocus, .startDate)

                XCTAssertNotNil(view.startDateText)
                XCTAssertNil(view.startTimeText)
                XCTAssertNil(view.durationText)

                XCTAssertNil(view.nextButtonAction)

                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testEditingStartTime() {
        let expectation = self.expectation(description: "")
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            view.beginEditingStartTime()

            DispatchQueue.main.async {
                XCTAssertNotNil(state.startDate)
                XCTAssertNil(state.duration)
                XCTAssertFalse(state.hasFocusedDate)
                XCTAssertTrue(state.hasFocusedTime)

                XCTAssertEqual(view.editingFocus, .startTime)

                XCTAssertNil(view.startDateText)
                XCTAssertNotNil(view.startTimeText)
                XCTAssertNil(view.durationText)

                XCTAssertNil(view.nextButtonAction)

                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testEditingDuration() {
        let expectation = self.expectation(description: "")
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            view.beginEditingDuration()

            DispatchQueue.main.async {
                XCTAssertNil(state.startDate)
                XCTAssertNotNil(state.duration)
                XCTAssertFalse(state.hasFocusedDate)
                XCTAssertFalse(state.hasFocusedTime)

                XCTAssertEqual(view.editingFocus, .duration)

                XCTAssertNil(view.startDateText)
                XCTAssertNil(view.startTimeText)
                XCTAssertNotNil(view.durationText)

                XCTAssertNil(view.nextButtonAction)

                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testEditingRequiredFieldsEnablesNextButton() {
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            state.hasFocusedDate = true
            state.hasFocusedTime = true
            state.startDate = .stub
            state.duration = .fortyFiveMinutes
            XCTAssertNotNil(view.nextButtonAction)
        }
    }

    func testNextButtonSetsStudentDetailsInContext() {
        let (context, state, view) = schedulingView

        XCTAssertView(view) { view in
            state.hasFocusedDate = true
            state.hasFocusedTime = true
            state.startDate = Date(timeIntervalSince1970: 1586914107)
            state.duration = .fortyFiveMinutes

            view.nextButtonAction?()

            XCTAssertEqual(
                context.schedule,
                Schedule(startDate: Date(timeIntervalSince1970: 1586914107), duration: .fortyFiveMinutes)
            )
        }
    }
}
