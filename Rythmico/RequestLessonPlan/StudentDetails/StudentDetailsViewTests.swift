import XCTest
import SwiftUI
@testable import Rythmico

final class StudentDetailsViewTests: XCTestCase {
    var studentDetailsView: (RequestLessonPlanContext, EditingCoordinatorSpy, StudentDetailsView) {
        let instrument = Instrument(id: "ABC", name: "Violin", icon: Image(systemSymbol: ._00Circle))
        let context = RequestLessonPlanContext()
        let editingCoordinator = EditingCoordinatorSpy()
        return (
            context,
            editingCoordinator,
            StudentDetailsView(
                instrument: instrument,
                state: .init(),
                context: context,
                editingCoordinator: editingCoordinator,
                dispatchQueue: .none
            )
        )
    }

    func testInitialValues() {
        let (context, editingCoordinator, view) = studentDetailsView

        XCTAssertView(view) { view in
            XCTAssertNil(context.student)
            XCTAssertEqual(editingCoordinator.endEditingCount, 0)

            XCTAssertFalse(view.subtitle.isEmpty)
            XCTAssertEqual(view.selectedInstrumentName, "Violin")

            XCTAssertEqual(view.state.name, "")

            XCTAssertNil(view.state.dateOfBirth)
            XCTAssertNil(view.dateOfBirthText)
            XCTAssertFalse(view.dateOfBirthPlaceholderText.isEmpty)

            XCTAssertNil(view.state.gender)

            XCTAssertEqual(view.aboutNameTextPart.string, "Student")
            XCTAssertEqual(view.state.about, "")

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingHidesSubtitle() {
        let (_, editingCoordinator, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.textFieldEditingChanged(true)
            XCTAssertTrue(view.subtitle.isEmpty)
            view.textFieldEditingChanged(false)
            XCTAssertFalse(view.subtitle.isEmpty)

            view.startEditingDateOfBirth()
            XCTAssertTrue(view.subtitle.isEmpty)
            view.endEditingDateOfBirth()
            XCTAssertFalse(view.subtitle.isEmpty)

            XCTAssertEqual(editingCoordinator.endEditingCount, 1)

            view.textFieldEditingChanged(true)
            view.startEditingDateOfBirth()
            XCTAssertTrue(view.subtitle.isEmpty)
            view.textFieldEditingChanged(false)
            view.endEditingDateOfBirth()
            XCTAssertFalse(view.subtitle.isEmpty)

            XCTAssertEqual(editingCoordinator.endEditingCount, 2)

            view.startEditingDateOfBirth()
            view.textFieldEditingChanged(true)
            XCTAssertTrue(view.subtitle.isEmpty)
            view.endEditingDateOfBirth()
            view.textFieldEditingChanged(false)
            XCTAssertFalse(view.subtitle.isEmpty)

            XCTAssertEqual(editingCoordinator.endEditingCount, 3)
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
