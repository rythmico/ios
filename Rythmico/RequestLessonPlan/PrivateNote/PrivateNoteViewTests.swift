import XCTest
@testable import Rythmico
import ViewInspector

extension PrivateNoteView: Inspectable {}

final class PrivateNoteViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
    }

    var privateNoteView: (RequestLessonPlanContext, PrivateNoteView.ViewState, PrivateNoteView) {
        let context = RequestLessonPlanContext()
        let state = PrivateNoteView.ViewState()
        return (
            context,
            state,
            PrivateNoteView(
                state: state,
                context: context
            )
        )
    }

    func testInitialValues() {
        let (context, state, view) = privateNoteView

        XCTAssertView(view) { view in
            XCTAssertNil(context.privateNote)
            XCTAssertEqual(state.privateNote, "")
            XCTAssertEqual(view.editingFocus, .none)
        }
    }

    func testEditingNote() {
        let (_, _, view) = privateNoteView

        XCTAssertView(view) { view in
            view.noteEditingChanged(true)
            XCTAssertEqual(view.editingFocus, .privateNote)
            view.noteEditingChanged(false)
            XCTAssertEqual(view.editingFocus, .none)
        }
    }

    func testNextButtonSetsPrivateNoteInContext() {
        let (context, state, view) = privateNoteView

        XCTAssertView(view) { view in
            state.privateNote = """
            Whilst not a dealbreaker, I'd like someone with experience teaching younger kids with visual impairements.



              Again, not a dealbreaker. But it  would be very        nice.


            """

            view.nextButtonAction()

            XCTAssertEqual(
                context.privateNote,
                """
                Whilst not a dealbreaker, I'd like someone with experience teaching younger kids with visual impairements.
                Again, not a dealbreaker. But it would be very nice.
                """
            )
        }
    }
}
