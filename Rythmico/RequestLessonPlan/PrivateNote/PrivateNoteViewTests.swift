import XCTest
@testable import Rythmico

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
            XCTAssertTrue(view.editingFocus.isNone)
        }
    }

    func testEditingNote() {
        let (_, _, view) = privateNoteView

        XCTAssertView(view) { view in
            view.noteEditingChanged(true)
            XCTAssertTrue(view.editingFocus.isTextField)
            view.noteEditingChanged(false)
            XCTAssertTrue(view.editingFocus.isNone)
        }
    }

    func testEndEditing() {
        let (_, _, view) = privateNoteView

        XCTAssertView(view) { view in
            view.noteEditingChanged(true)
            view.endEditing()
            XCTAssertTrue(view.editingFocus.isNone)
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
