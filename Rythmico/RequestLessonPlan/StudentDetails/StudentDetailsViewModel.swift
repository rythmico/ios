import Foundation
import SwiftUI
import ViewModel
import Then

final class StudentDetailsViewModel: ViewModelObject<StudentDetailsViewData> {
    private let context: RequestLessonPlanContextProtocol

    private let dateFormatter = DateFormatter().then {
        $0.dateStyle = .long
    }

    private var name: String? {
        didSet { viewData.aboutNameTextPart = aboutNameTextPart }
    }

    private var dateOfBirth: Date? {
        didSet {
            dateOfBirth.map {
                viewData.dateOfBirthTextFieldViewData.text = .constant(dateFormatter.string(from: $0))
            }
        }
    }

    private let dateOfBirthPlaceholder = Date().addingTimeInterval(-10 * 365 * 24 * 3600) // 10-year-old students on average

    private var about: String?

    init(
        context: RequestLessonPlanContextProtocol,
        instrument: Instrument,
        editingCoordinator: EditingCoordinator
    ) {
        self.context = context
        super.init()

        self.viewData = ViewData(
            selectedInstrumentName: instrument.name,
            nameTextFieldViewData: TextFieldViewData(
                placeholder: "Enter Name...",
                text: Binding(
                    get: { self.name ?? "" },
                    set: { self.name = $0 }
                ),
                onEditingChanged: { if $0 { self.endEditingDateOfBirth() } }
            ),
            dateOfBirthTextFieldViewData: TextFieldViewData(
                placeholder: dateFormatter.string(from: dateOfBirthPlaceholder),
                text: Binding.constant(""),
                onEditingChanged: {
                    if $0 {
                        DispatchQueue.main.async {
                            editingCoordinator.endEditing()
                            self.startEditingDateOfBirth()
                        }
                    }
                }
            ),
            datePickerViewData: nil,
            aboutNameTextPart: aboutNameTextPart,
            aboutTextFieldViewData: TextFieldViewData(
                placeholder: "Existing instrument prowess etc.",
                text: Binding(
                    get: { self.about ?? "" },
                    set: { self.about = $0 }
                ),
                onEditingChanged: { if $0 { self.endEditingDateOfBirth() } }
            )
        )
    }

    private var aboutNameTextPart: MultiStyleText.Part {
        let firstName = name.map { $0.components(separatedBy: " ") }?.first
        return .init(
            firstName ?? "Student",
            weight: .regular,
            color: firstName.map { _ in .rythmicoPurple }
        )
    }

    func startEditingDateOfBirth() {
        viewData.datePickerViewData = DatePickerViewData(
            label: "",
            selection: Binding(
                get: { self.dateOfBirth ?? self.dateOfBirthPlaceholder },
                set: { self.dateOfBirth = $0 }
            ),
            displayedComponents: .date
        )

        // set date of birth to initial value on first edit
        if dateOfBirth == nil {
            dateOfBirth = dateOfBirthPlaceholder
        }
    }

    func endEditingDateOfBirth() {
        viewData.datePickerViewData = nil
    }
}
