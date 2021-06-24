import FoundationSugar
import XCTest
@testable import Rythmico
import ViewInspector

extension SchedulingView: Inspectable {}

final class SchedulingViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
    }

    var schedulingView: (RequestLessonPlanFlow, SchedulingView.ViewState, SchedulingView) {
        let flow = RequestLessonPlanFlow()
        let state = SchedulingView.ViewState()
        return (
            flow,
            state,
            SchedulingView(
                state: state,
                instrument: .guitar,
                setter: { flow.schedule = $0 }
            )
        )
    }

    func testInitialValues() throws {
        let (flow, state, view) = schedulingView

        try XCTAssertView(view) { view in
            XCTAssertNil(flow.schedule)

            try XCTAssertText(
                XCTUnwrap(view.subtitle),
                "Enter when you want the Guitar lessons to commence and for how long"
            )

            XCTAssertNil(state.startDate)
            XCTAssertNil(state.startTime)
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
                XCTAssertNil(state.startTime)
                XCTAssertNil(state.duration)

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
            view.onEditingStartTimeChanged(true)

            DispatchQueue.main.async {
                XCTAssertNil(state.startDate)
                XCTAssertNotNil(state.startTime)
                XCTAssertNil(state.duration)

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
            view.onEditingDurationChanged(true)

            DispatchQueue.main.async {
                XCTAssertNil(state.startDate)
                XCTAssertNil(state.startTime)
                XCTAssertNotNil(state.duration)

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
            state.startDate = .stub
            state.startTime = .stub
            state.duration = .fortyFiveMinutes
            XCTAssertNotNil(view.nextButtonAction)
        }
    }

    func testNextButtonSetsStudentDetailsInContext() {
        let (flow, state, view) = schedulingView

        XCTAssertView(view) { view in
            state.startDate = "2021-07-03T13:30:20Z"
            state.startTime = "2021-07-03T17:25:00Z"
            state.duration = .fortyFiveMinutes

            view.nextButtonAction?()

            XCTAssertEqual(
                flow.schedule,
                Schedule(startDate: "2021-07-03T17:25:00Z", duration: .fortyFiveMinutes)
            )
        }
    }
}
