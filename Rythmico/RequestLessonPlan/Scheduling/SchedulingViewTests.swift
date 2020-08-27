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
                instrument: .guitar,
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

            XCTAssertTrue(view.startDateText.isEmpty)
            XCTAssertTrue(view.startTimeText.isEmpty)
            XCTAssertTrue(view.durationText.isEmpty)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingStartDate() {
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            view.beginEditingStartDate()

            XCTAssertNotNil(state.startDate)
            XCTAssertNil(state.startTime)
            XCTAssertNil(state.duration)

            XCTAssertTrue(view.editingFocus.isStartDate)

            XCTAssertFalse(view.startDateText.isEmpty)
            XCTAssertTrue(view.startTimeText.isEmpty)
            XCTAssertTrue(view.durationText.isEmpty)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingStartTime() {
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            view.beginEditingStartTime()

            XCTAssertNil(state.startDate)
            XCTAssertNotNil(state.startTime)
            XCTAssertNil(state.duration)

            XCTAssertTrue(view.editingFocus.isStartTime)

            XCTAssertTrue(view.startDateText.isEmpty)
            XCTAssertFalse(view.startTimeText.isEmpty)
            XCTAssertTrue(view.durationText.isEmpty)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingDuration() {
        let (_, state, view) = schedulingView

        XCTAssertView(view) { view in
            view.beginEditingDuration()

            XCTAssertNil(state.startDate)
            XCTAssertNil(state.startTime)
            XCTAssertNotNil(state.duration)

            XCTAssertTrue(view.editingFocus.isDuration)

            XCTAssertTrue(view.startDateText.isEmpty)
            XCTAssertTrue(view.startTimeText.isEmpty)
            XCTAssertEqual(view.durationText, "45 minutes")

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEndEditing() {
        let (_, _, view) = schedulingView

        XCTAssertView(view) { view in
            view.beginEditingStartDate()
            view.endEditing()
            XCTAssertTrue(view.editingFocus.isNone)
        }
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
        let (context, state, view) = schedulingView

        XCTAssertView(view) { view in
            state.startDate = Date(timeIntervalSince1970: 1586914107)
            state.startTime = Date(timeIntervalSince1970: 25200)
            state.duration = .fortyFiveMinutes

            view.nextButtonAction?()

            XCTAssertEqual(
                context.schedule,
                Schedule(startDate: Date(timeIntervalSince1970: 1586934000), duration: .fortyFiveMinutes)
            )
        }
    }
}
