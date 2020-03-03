import XCTest
import SwiftUI
@testable import Rythmico

final class StudentDetailsViewTests: XCTestCase {
    var studentDetailsView: (RequestLessonPlanContextProtocol, EditingCoordinatorSpy, StudentDetailsView) {
        let instrument = Instrument(id: "ABC", name: "Violin", icon: Image(systemSymbol: ._00Circle))
        let context = RequestLessonPlanContext(instrument: instrument, student: nil)
        let editingCoordinator = EditingCoordinatorSpy()
        return (
            context,
            editingCoordinator,
            StudentDetailsView(context: context, editingCoordinator: editingCoordinator, dispatchQueue: .none)!
        )
    }

    func testInitialValues() {
        let (context, editingCoordinator, view) = studentDetailsView

        XCTAssertView(view) { view in
            XCTAssertNil(context.student)
            XCTAssertEqual(editingCoordinator.endEditingCount, 0)

            XCTAssertFalse(view.subtitle.isEmpty)
            XCTAssertEqual(view.selectedInstrumentName, "Violin")

            XCTAssertEqual(view.name, "")

            XCTAssertNil(view.dateOfBirth)
            XCTAssertNil(view.dateOfBirthText)
            XCTAssertFalse(view.dateOfBirthPlaceholderText.isEmpty)

            XCTAssertNil(view.gender)

            XCTAssertEqual(view.aboutNameTextPart.string, "Student")
            XCTAssertEqual(view.about, "")

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
            view.name = "David"
            XCTAssertEqual(view.aboutNameTextPart.string, "David")

            view.name = "Jesse Bildner"
            XCTAssertEqual(view.aboutNameTextPart.string, "Jesse")

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingDateOfBirth() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.dateOfBirth = Date()
            XCTAssertNotNil(view.dateOfBirthText)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingGender() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.gender = .male
            XCTAssertEqual(view.gender, .male)

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingAbout() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.about = "Something"
            XCTAssertEqual(view.about, "Something")

            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testEditingRequiredFieldsEnablesNextButton() throws {
        let (_, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            view.name = "David"
            view.dateOfBirth = Date()
            view.gender = .male

            XCTAssertNotNil(view.nextButtonAction)
        }
    }

    func testNextButtonSetsStudentDetailsInContext() throws {
        let (context, _, view) = studentDetailsView

        XCTAssertView(view) { view in
            let date = Date()

            view.name = "David"
            view.dateOfBirth = date
            view.gender = .male
            view.nextButtonAction?()

            XCTAssertEqual(
                context.student,
                Student(
                    name: "David",
                    dateOfBirth: date,
                    gender: .male,
                    about: ""
                )
            )
        }
    }
}
