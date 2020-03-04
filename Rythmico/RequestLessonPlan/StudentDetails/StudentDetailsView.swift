import SwiftUI
import KeyboardObserver
import Sugar
import Then

protocol StudentDetailsContext {
    func setStudent(_ student: Student)
}

struct StudentDetailsView: View, TestableView {
    private enum Const {
        // 10 years old
        static let averageStudentAge: TimeInterval = 10 * 365 * 24 * 3600
    }

    final class ViewState: ObservableObject {
        @Published var name = ""
        @Published var dateOfBirth: Date?
        @Published var gender: Gender?
        @Published var about = ""
    }

    private let instrument: Instrument
    private let context: StudentDetailsContext
    private let editingCoordinator: EditingCoordinator
    private let dateFormatter = DateFormatter().then { $0.dateStyle = .long }
    private let dispatchQueue: DispatchQueue?

    init(
        instrument: Instrument,
        state: ViewState,
        context: StudentDetailsContext,
        editingCoordinator: EditingCoordinator,
        dispatchQueue: DispatchQueue?
    ) {
        self.instrument = instrument
        self.state = state
        self.context = context
        self.editingCoordinator = editingCoordinator
        self.dispatchQueue = dispatchQueue
    }

    // MARK: - ViewState -
    @ObservedObject var state: ViewState

    // MARK: - Subtitle -
    var selectedInstrumentName: String { instrument.name }
    var subtitle: [MultiStyleText.Part] {
        !isEditing
            ? [
                .init("Enter the details of the student who will learn "),
                .init(selectedInstrumentName, weight: .bold)
            ]
            : []
    }

    @State private var isEditing = false

    // MARK: - Name -
    private var sanitizedName: String? {
        state.name
            .trimmingCharacters(in: .whitespacesAndNewlines)

            // removes repeated whitespaces and newlines
            .components(separatedBy: .whitespacesAndNewlines)
            .filter(\.isEmpty.not)
            .joined(separator: " ")

            .nilIfEmpty
    }

    func textFieldEditingChanged(_ isEditing: Bool) {
        if isEditing {
            self.endEditingDateOfBirth()
        }
        self.isEditing = isEditing
    }

    // MARK: - Date of Birth -
    var dateOfBirthText: String? { state.dateOfBirth.map(dateFormatter.string(from:)) }
    var dateOfBirthPlaceholderText: String { dateFormatter.string(from: dateOfBirthPlaceholder) }

    func startEditingDateOfBirth() {
        let showDateOfBirthPicker = {
            self.editingCoordinator.endEditing()
            self.isDateOfBirthPickerHidden = false
        }

        dispatchQueue?.async(execute: showDateOfBirthPicker) ?? showDateOfBirthPicker()

        isEditing = true

        // set date of birth to initial value on first edit
        if state.dateOfBirth == nil {
            state.dateOfBirth = dateOfBirthPlaceholder
        }
    }

    func endEditingDateOfBirth() {
        isDateOfBirthPickerHidden = true
        isEditing = false
    }

    @State
    private var isDateOfBirthPickerHidden = true
    private let dateOfBirthPlaceholder = Date().addingTimeInterval(-Const.averageStudentAge)
    private func dateFieldEditingChanged(_ isEditing: Bool) { if isEditing { startEditingDateOfBirth() } }

    // MARK: - About -
    var aboutNameTextPart: MultiStyleText.Part {
        let firstNameComponent = sanitizedName?
            .components(separatedBy: " ")
            .first

        return .init(
            firstNameComponent ?? "Student",
            weight: .regular,
            color: firstNameComponent != nil ? .rythmicoPurple : .rythmicoForeground
        )
    }

    private var sanitizedAbout: String {
        state.about
            .trimmingCharacters(in: .whitespacesAndNewlines)

            // removes repeated whitespaces
            .components(separatedBy: .whitespaces)
            .filter(\.isEmpty.not)
            .joined(separator: " ")

            // removes repeated newlines
            .components(separatedBy: .newlines)
            .filter(\.isEmpty.not)
            .joined(separator: "\n\n")
    }

    // MARK: - Next Button -
    var nextButtonAction: Action? {
        guard
            let name = sanitizedName,
            let dateOfBirth = state.dateOfBirth,
            let gender = state.gender
        else {
            return nil
        }

        return {
            self.context.setStudent(
                Student(
                    name: name,
                    dateOfBirth: dateOfBirth,
                    gender: gender,
                    about: self.sanitizedAbout
                )
            )
        }
    }

    // MARK: - Body -
    var didAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Student Details", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .spacingLarge) {
                        TitleContentView(title: "Full Name") {
                            CustomTextField(
                                "Enter Name...",
                                text: $state.name,
                                textContentType: .name,
                                autocapitalizationType: .words,
                                onEditingChanged: textFieldEditingChanged
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                        }
                        TitleContentView(title: "Date of Birth") {
                            CustomTextField(
                                dateOfBirthPlaceholderText,
                                text: .constant(dateOfBirthText ?? ""),
                                isSelectable: false,
                                onEditingChanged: dateFieldEditingChanged
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                        }
                        TitleContentView(title: "Gender") {
                            GenderSelectionView(selection: $state.gender)
                        }
                        TitleContentView(title: [.init("About "), aboutNameTextPart]) {
                            MultilineTextField(
                                "Existing instrument prowess etc.",
                                text: $state.about,
                                onEditingChanged: textFieldEditingChanged
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                        }
                    }
                    .rythmicoFont(.body)
                    .accentColor(.rythmicoPurple)
                    .inset(.bottom, .spacingMedium)
                }
                .avoidingKeyboard()

                ZStack(alignment: .bottom) {
                    nextButtonAction.map {
                        FloatingButton(title: "Next", action: $0).padding(.horizontal, -.spacingMedium)
                    }

                    if !isDateOfBirthPickerHidden {
                        FloatingDatePicker(
                            selection: Binding(
                                get: { self.state.dateOfBirth ?? self.dateOfBirthPlaceholder },
                                set: { self.state.dateOfBirth = $0 }
                            ),
                            doneButtonAction: endEditingDateOfBirth
                        ).padding(.horizontal, -.spacingMedium)
                    }
                }
            }
            .animation(.easeInOut(duration: .durationMedium), value: isDateOfBirthPickerHidden)
            .animation(.easeInOut(duration: .durationShort), value: nextButtonAction != nil)
        }
        .animation(.easeInOut(duration: .durationMedium), value: isEditing)
        .onDisappear(perform: editingCoordinator.endEditing)
        .onAppear { self.didAppear?(self) }
    }
}

struct StudentDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        StudentDetailsView(
            instrument: Instrument(
                id: "Piano",
                name: "Piano",
                icon: Image(decorative: Asset.instrumentIconPiano.name)
            ),
            state: StudentDetailsView.ViewState(),
            context: RequestLessonPlanContext(),
            editingCoordinator: UIApplication.shared,
            dispatchQueue: .main
        )
    }
}
