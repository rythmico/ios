import XCTest
import SwiftUI
import Sugar
@testable import Rythmico

final class StudentDetailsViewTests: XCTestCase {
    var studentDetailsView: (RequestLessonPlanContext, KeyboardDismisserSpy, StudentDetailsView) {
        let instrument = Instrument.singing
        let context = RequestLessonPlanContext()
        let editingCoordinator = KeyboardDismisserSpy()
        return (
            context,
            editingCoordinator,
            StudentDetailsView(
                instrument: instrument,
                state: .init(),
                context: context,
                keyboardDismisser: editingCoordinator
            )
        )
    }

    func testInitialValues() {
        let (context, keyboardDismisser, view) = studentDetailsView

        XCTAssertView(view) { view in
            XCTAssertNil(context.student)
            XCTAssertEqual(keyboardDismisser.dismissKeyboardCount, 0)

            XCTAssertEqual(
                view.subtitle.string,
                "Enter the details of the student who will learn Singing"
            )

            XCTAssertEqual(view.state.name, .empty)

            XCTAssertNil(view.state.dateOfBirth)
            XCTAssertNil(view.dateOfBirthText)
            XCTAssertFalse(view.dateOfBirthPlaceholderText.isEmpty)

            XCTAssertNil(view.state.gender)

            XCTAssertEqual(view.aboutNameTextPart.string, "Student")
            XCTAssertEqual(view.state.about, .empty)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingName() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.state.name = "David"
            XCTAssertEqual(view.aboutNameTextPart.string, "David")

            view.state.name = "  Jesse Bildner \n   "
            XCTAssertEqual(view.aboutNameTextPart.string, "Jesse")

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingDateOfBirth() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.state.dateOfBirth = Date()
            XCTAssertNotNil(view.dateOfBirthText)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingGender() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.state.gender = .male
            XCTAssertEqual(view.state.gender, .male)

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
            view.state.dateOfBirth = Date()
            view.state.gender = .male

            XCTAssertNotNil(view.nextButtonAction)
        }
    }

    func testNextButtonSetsStudentDetailsInContext() throws {
        let (context, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            let date = Date()

            view.state.name = "  David    Roman  "
            view.state.dateOfBirth = date
            view.state.gender = .male
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
                    dateOfBirth: date,
                    gender: .male,
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
