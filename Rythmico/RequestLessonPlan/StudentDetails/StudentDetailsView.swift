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
        @Published var name = String()
        @Published var dateOfBirth: Date?
        @Published var gender: Gender?
        @Published var about = String()
    }

    @ObservedObject var state: ViewState

    enum EditingFocus: EditingFocusEnum {
        // TODO: remove with Swift 5.3
        static var none: Self { ._none }
        static var textField: Self { ._textField }
        var isNone: Bool { is_none }
        var isTextField: Bool { is_textField }
        case _none
        case _textField
        case dateOfBirth
    }

    @ObservedObject
    private var editingCoordinator: EditingCoordinator<EditingFocus>
    private var editingFocus: EditingFocus {
        get { editingCoordinator.focus }
        nonmutating set { editingCoordinator.focus = newValue }
    }

    private let instrument: Instrument
    private let context: StudentDetailsContext

    init(
        instrument: Instrument,
        state: ViewState,
        context: StudentDetailsContext,
        keyboardDismisser: KeyboardDismisser
    ) {
        self.instrument = instrument
        self.state = state
        self.context = context
        self.editingCoordinator = EditingCoordinator(keyboardDismisser: keyboardDismisser)
    }

    // MARK: - Subtitle -
    var subtitle: [MultiStyleText.Part] {
        editingFocus.isNone
            ? "Enter the details of the student who will learn " + instrument.name.bold
            : .empty
    }

    // MARK: - Name -
    private var sanitizedName: String? {
        state.name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .removingRepetitionOf(.whitespace)
            .removingAll(.newline)
            .nilIfEmpty
    }

    // MARK: - Date of Birth -
    var dateOfBirthText: String? { state.dateOfBirth.map(dateFormatter.string(from:)) }
    var dateOfBirthPlaceholderText: String { dateFormatter.string(from: dateOfBirthPlaceholder) }

    private let dateFormatter = DateFormatter().then { $0.dateStyle = .long }
    private let dateOfBirthPlaceholder = Date().addingTimeInterval(-Const.averageStudentAge)

    // MARK: - About -
    var aboutNameTextPart: MultiStyleText.Part {
        sanitizedName?.firstWord.map { $0.color(.rythmicoPurple) } ?? "Student"
    }

    private var sanitizedAbout: String {
        state.about
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .removingRepetitionOf(.whitespace)
            .repeating(.newline, count: 2) // FIXME: set line spacing instead
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
                                text: .constant(dateOfBirthText ?? .empty),
                                isEditable: false
                            )
                            .modifier(RoundedThinOutlineContainer(padded: false))
                            .onTapGesture { self.dateOfBirthEditingChanged(true) }
                        }
                        TitleContentView(title: "Gender") {
                            GenderSelectionView(selection: $state.gender)
                        }
                        TitleContentView(title: "About " + aboutNameTextPart) {
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
                    .onBackgroundTapGesture(perform: endEditingAllFields)
                }
                .avoidingKeyboard()

                ZStack(alignment: .bottom) {
                    nextButtonAction.map {
                        FloatingButton(title: "Next", action: $0).padding(.horizontal, -.spacingMedium)
                    }

                    if editingFocus.isDateOfBirth {
                        FloatingDatePicker(
                            selection: Binding(
                                get: { self.state.dateOfBirth ?? self.dateOfBirthPlaceholder },
                                set: { self.state.dateOfBirth = $0 }
                            ),
                            doneButtonAction: { self.dateOfBirthEditingChanged(false) }
                        ).padding(.horizontal, -.spacingMedium)
                    }
                }
            }
            .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
            .animation(.easeInOut(duration: .durationShort), value: nextButtonAction != nil)
        }
        .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
        .onDisappear(perform: endEditingAllFields)
        .onAppear { self.didAppear?(self) }
    }

    func textFieldEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .textField : .none
    }

    func dateOfBirthEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .dateOfBirth : .none

        // set date of birth to initial value on first edit
        if isEditing, state.dateOfBirth == nil {
            state.dateOfBirth = dateOfBirthPlaceholder
        }
    }

    func endEditingAllFields() {
        editingFocus = .none
    }
}

struct StudentDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        StudentDetailsView(
            instrument: .pianoStub,
            state: StudentDetailsView.ViewState(),
            context: RequestLessonPlanContext(),
            keyboardDismisser: UIApplication.shared
        )
    }
}
