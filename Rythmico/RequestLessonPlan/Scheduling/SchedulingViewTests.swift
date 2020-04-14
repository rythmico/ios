import XCTest
@testable import Rythmico

final class SchedulingViewTests: XCTestCase {
    var schedulingView: (RequestLessonPlanContext, SchedulingView.ViewState, SchedulingView) {
        let context = RequestLessonPlanContext()
        let state = SchedulingView.ViewState()
        return (
            context,
            state,
            SchedulingView(
                instrument: .guitarStub,
                state: state,
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

            XCTAssertNil(state.startDate)
            XCTAssertNil(state.duration)

            XCTAssertTrue(view.editingFocus.isNone)

            XCTAssertEqual(view.startDateText, "")
            XCTAssertEqual(view.startTimeText, "")
            XCTAssertEqual(view.durationText, "")

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingStartDate() {
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            view.startDateEditingChanged(true)

            XCTAssertNotNil(state.startDate)
            XCTAssertNil(state.duration)

            XCTAssertTrue(view.editingFocus.isStartDate)

            XCTAssertFalse(view.startDateText.isEmpty)
            XCTAssertFalse(view.startTimeText.isEmpty)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingStartTime() {
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            view.startTimeEditingChanged(true)

            XCTAssertNotNil(state.startDate)
            XCTAssertNil(state.duration)

            XCTAssertTrue(view.editingFocus.isStartTime)

            XCTAssertFalse(view.startDateText.isEmpty)
            XCTAssertFalse(view.startTimeText.isEmpty)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingDuration() {
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            view.durationEditingChanged(true)

            XCTAssertNil(state.startDate)
            XCTAssertNotNil(state.duration)

            XCTAssertTrue(view.editingFocus.isDuration)

            XCTAssertTrue(view.startDateText.isEmpty)
            XCTAssertTrue(view.startTimeText.isEmpty)
            XCTAssertFalse(view.durationText.isEmpty)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEndEditing() {
        let (_, _, view) = schedulingView

        XCTAssertView(view) { view in
            view.startDateEditingChanged(true)
            view.endEditingAllFields()
            XCTAssertTrue(view.editingFocus.isNone)
        }
    }

    func testEditingRequiredFieldsEnablesNextButton() {
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            state.startDate = Date()
            state.duration = .fortyFiveMinutes
            XCTAssertNotNil(view.nextButtonAction)
        }
    }

    func testNextButtonSetsStudentDetailsInContext() {
        let (context, state, view) = schedulingView

        XCTAssertView(view) { view in
            let date = Date()
            state.startDate = date
            state.duration = .fortyFiveMinutes

            view.nextButtonAction?()

            XCTAssertEqual(
                context.schedule,
                Schedule(startDate: date, duration: .fortyFiveMinutes)
            )
        }
    }
}
