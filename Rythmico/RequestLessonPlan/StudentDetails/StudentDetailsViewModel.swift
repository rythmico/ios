import SwiftUI
import ViewModel
import Then

final class StudentDetailsViewModel: ViewModelObject<StudentDetailsViewData> {
    private let context: RequestLessonPlanContextProtocol

    private let dateFormatter = DateFormatter().then {
        $0.dateStyle = .long
    }

    private var name: String? {
        didSet {
            viewData.aboutNameTextPart = aboutNameTextPart
            studentDetailsChanged()
        }
    }

    private var dateOfBirth: Date? {
        didSet {
            dateOfBirth.map {
                viewData.dateOfBirthTextFieldViewData.text = .constant(dateFormatter.string(from: $0))
            }
            studentDetailsChanged()
        }
    }

    private let dateOfBirthPlaceholder = Date().addingTimeInterval(-10 * 365 * 24 * 3600) // 10-year-old students on average

    private var gender: Gender? {
        didSet { studentDetailsChanged() }
    }

    private var about: String?

    init(
        context: RequestLessonPlanContextProtocol,
        instrument: Instrument,
        editingCoordinator: EditingCoordinator
    ) {
        self.context = context
        super.init()

        self.viewData = ViewData(
            isEditing: false,
            selectedInstrumentName: instrument.name,
            nameTextFieldViewData: TextFieldViewData(
                placeholder: "Enter Name...",
                text: Binding(
                    get: { self.name ?? "" },
                    set: { self.name = $0 }
                ),
                onEditingChanged: self.textFieldEditingChanged
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
            genderSelection: Binding(
                get: { self.gender },
                set: { self.gender = $0 }
            ),
            aboutNameTextPart: aboutNameTextPart,
            aboutTextFieldViewData: TextFieldViewData(
                placeholder: "Existing instrument prowess etc.",
                text: Binding(
                    get: { self.about ?? "" },
                    set: { self.about = $0 }
                ),
                onEditingChanged: self.textFieldEditingChanged
            )
        )
    }

    private func textFieldEditingChanged(_ isEditing: Bool) {
        if isEditing {
            self.endEditingDateOfBirth()
        }
        viewData.isEditing = isEditing
    }

    private var aboutNameTextPart: MultiStyleText.Part {
        let firstName = name.map { $0.components(separatedBy: " ") }?.first
        return .init(
            firstName ?? "Student",
            weight: .regular,
            color: firstName != nil ? .rythmicoPurple : .rythmicoForeground
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

        viewData.isEditing = true

        // set date of birth to initial value on first edit
        if dateOfBirth == nil {
            dateOfBirth = dateOfBirthPlaceholder
        }
    }

    func endEditingDateOfBirth() {
        viewData.datePickerViewData = nil
        viewData.isEditing = false
    }

    private func studentDetailsChanged() {
        guard
            let name = name?.trimmingCharacters(in: .whitespacesAndNewlines),
            !name.isEmpty,
            let dateOfBirth = dateOfBirth,
            let gender = gender
        else {
            viewData.nextButtonAction = nil
            return
        }

        viewData.nextButtonAction = {
            self.context.student = Student(
                name: name,
                dateOfBirth: dateOfBirth,
                gender: gender,
                about: self.about
            )
        }
    }
}
