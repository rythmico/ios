import XCTest
@testable import Rythmico
import ViewInspector

extension PrivateNoteView: Inspectable {}

final class PrivateNoteViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
    }

    var privateNoteView: (RequestLessonPlanFlow, PrivateNoteView.ViewState, PrivateNoteView) {
        let flow = RequestLessonPlanFlow()
        let state = PrivateNoteView.ViewState()
        return (
            flow,
            state,
            PrivateNoteView(
                state: state,
                setter: { flow.privateNote = $0 }
            )
        )
    }

    func testInitialValues() {
        let (flow, state, view) = privateNoteView

        XCTAssertView(view) { view in
            XCTAssertNil(flow.privateNote)
            XCTAssertEqual(state.privateNote, "")
            XCTAssertEqual(view.focus, .none)
        }
    }

    func testEditingNote() {
        let (_, _, view) = privateNoteView

        XCTAssertView(view) { view in
            view.noteEditingChanged(true)
            XCTAssertEqual(view.focus, .privateNote)
            view.noteEditingChanged(false)
            XCTAssertEqual(view.focus, .none)
        }
    }

    func testNextButtonSetsPrivateNoteInContext() {
        let (flow, state, view) = privateNoteView

        XCTAssertView(view) { view in
            state.privateNote = """
            Whilst not a dealbreaker, I'd like someone with experience teaching younger kids with visual impairements.



              Again, not a dealbreaker. But it  would be very        nice.


            """

            view.nextButtonAction()

            XCTAssertEqual(
                flow.privateNote,
                """
                Whilst not a dealbreaker, I'd like someone with experience teaching younger kids with visual impairements.
                Again, not a dealbreaker. But it would be very nice.
                """
            )
        }
    }
}
