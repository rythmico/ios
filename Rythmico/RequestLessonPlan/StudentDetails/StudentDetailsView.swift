import SwiftUI
import KeyboardObserver
import Sugar
import Then

struct StudentDetailsView: View, TestableView {
    private enum Const {
        // 10 years old
        static let averageStudentAge: TimeInterval = 10 * 365 * 24 * 3600
    }

    private let context: RequestLessonPlanContextProtocol
    private let instrument: Instrument
    private let editingCoordinator: EditingCoordinator
    private let dateFormatter = DateFormatter().then { $0.dateStyle = .long }
    private let dispatchQueue: DispatchQueue?

    init?(
        context: RequestLessonPlanContextProtocol,
        editingCoordinator: EditingCoordinator,
        dispatchQueue: DispatchQueue?
    ) {
        guard let instrument = context.instrument else {
            return nil
        }
        self.context = context
        self.instrument = instrument
        self.editingCoordinator = editingCoordinator
        self.dispatchQueue = dispatchQueue
    }

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
    @State var name = ""

    private var sanitizedName: String? {
        name
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
    @State
    var dateOfBirth: Date?
    var dateOfBirthText: String? { dateOfBirth.map(dateFormatter.string(from:)) }
    var dateOfBirthPlaceholderText: String { dateFormatter.string(from: dateOfBirthPlaceholder) }

    func startEditingDateOfBirth() {
        let showDateOfBirthPicker = {
            self.editingCoordinator.endEditing()
            self.isDateOfBirthPickerHidden = false
        }

        dispatchQueue?.async(execute: showDateOfBirthPicker) ?? showDateOfBirthPicker()

        isEditing = true

        // set date of birth to initial value on first edit
        if dateOfBirth == nil {
            dateOfBirth = dateOfBirthPlaceholder
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

    // MARK: - Gender -
    @State var gender: Gender?

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

    @State
    var about = ""

    private var sanitizedAbout: String {
        about
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
            let dateOfBirth = dateOfBirth,
            let gender = gender
        else {
            return nil
        }

        return {
            self.context.student = Student(
                name: name,
                dateOfBirth: dateOfBirth,
                gender: gender,
                about: self.sanitizedAbout
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
                                Text("Enter Name...").foregroundColor(.rythmicoGray30),
                                text: $name,
                                onEditingChanged: textFieldEditingChanged
                            )
                            .textContentType(.name)
                            .autocapitalization(.words)
                            .modifier(RoundedThinOutlineContainer())
                        }
                        TitleContentView(title: "Date of Birth") {
                            CustomTextField(
                                Text(dateOfBirthPlaceholderText).foregroundColor(.rythmicoGray30),
                                text: .constant(dateOfBirthText ?? ""),
                                onEditingChanged: dateFieldEditingChanged
                            ).modifier(RoundedThinOutlineContainer())
                        }
                        TitleContentView(title: "Gender") {
                            GenderSelectionView(selection: $gender)
                        }
                        TitleContentView(title: [.init("About "), aboutNameTextPart]) {
                            MultilineTextField(
                                "Existing instrument prowess etc.",
                                text: $about,
                                onEditingChanged: textFieldEditingChanged
                            ).modifier(RoundedThinOutlineContainer())
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
                                get: { self.dateOfBirth ?? self.dateOfBirthPlaceholder },
                                set: { self.dateOfBirth = $0 }
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
            context: RequestLessonPlanContext(
                instrument: Instrument(id: "Piano", name: "Piano", icon: Image(decorative: Asset.instrumentIconPiano.name))
            ),
            editingCoordinator: UIApplication.shared,
            dispatchQueue: .main
        )
    }
}
