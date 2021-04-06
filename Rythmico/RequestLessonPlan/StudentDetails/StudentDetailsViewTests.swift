import XCTest
import SwiftUI
import FoundationSugar
@testable import Rythmico
import ViewInspector

extension StudentDetailsView: Inspectable {}

final class StudentDetailsViewTests: XCTestCase {
    var studentDetailsView: (RequestLessonPlanContext, KeyboardDismisserSpy, StudentDetailsView) {
        let instrument = Instrument.singing
        let context = RequestLessonPlanContext()
        let keyboardDismisser = KeyboardDismisserSpy()
        Current.keyboardDismisser = keyboardDismisser
        return (
            context,
            keyboardDismisser,
            StudentDetailsView(
                instrument: instrument,
                state: .init(),
                context: context
            )
        )
    }

    func testInitialValues() throws {
        let (context, keyboardDismisser, view) = studentDetailsView

        try XCTAssertView(view) { view in
            XCTAssertNil(context.student)
            XCTAssertEqual(keyboardDismisser.dismissKeyboardCount, 0)

            try XCTAssertText(
                XCTUnwrap(view.subtitle),
                "Enter the details of the student who will be learning Singing"
            )

            XCTAssertEqual(view.state.name, .empty)

            XCTAssertNil(view.state.dateOfBirth)
            XCTAssertNil(view.dateOfBirthText)
            XCTAssertFalse(view.dateOfBirthPlaceholderText.isEmpty)

            try XCTAssertText(view.aboutHeaderTitle, "About Student")
            XCTAssertEqual(view.state.about, .empty)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingName() throws {
        let (_, _, view) = studentDetailsView

        try XCTAssertView(view) { view in
            view.state.name = "David"
            try XCTAssertText(view.aboutHeaderTitle, "About David")

            view.state.name = "  Jesse Bildner \n   "
            try XCTAssertText(view.aboutHeaderTitle, "About Jesse")

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingDateOfBirth() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.state.dateOfBirth = .stub
            XCTAssertNotNil(view.dateOfBirthText)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingAbout() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.state.about = "Something"
            XCTAssertEqual(view.state.about, "Something")

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingRequiredFieldsEnablesNextButton() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.state.name = "David"
            view.state.dateOfBirth = .stub

            XCTAssertNotNil(view.nextButtonAction)
        }
    }

    func testNextButtonSetsStudentDetailsInContext() throws {
        let (context, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.state.name = "  David    Roman  "
            view.state.dateOfBirth = .stub
            view.state.about = """
               David is an exceptional piano student, however    whitespaces are not his thing.    Like at all.


            Anyway we can help    him out a bit   with this.

              Teach him how whitespaces and newlines are properly done, please.



            """
            view.nextButtonAction?()

            XCTAssertEqual(
                context.student,
                Student(
                    name: "David Roman",
                    dateOfBirth: .stub,
                    about: """
                    David is an exceptional piano student, however whitespaces are not his thing. Like at all.
                    Anyway we can help him out a bit with this.
                    Teach him how whitespaces and newlines are properly done, please.
                    """
                )
            )
        }
    }
}
