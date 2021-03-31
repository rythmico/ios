import SwiftUI
import FoundationSugar

protocol StudentDetailsContext {
    func setStudent(_ student: Student)
}

struct StudentDetailsView: View, EditableView, TestableView {
    private enum Const {
        static let averageStudentAge: (Int, Calendar.Component) = (10, .year)
    }

    final class ViewState: ObservableObject {
        @Published var name = String()
        @Published var dateOfBirth: Date?
        @Published var about = String()
    }

    @ObservedObject var state: ViewState

    enum EditingFocus: EditingFocusEnum, CaseIterable {
        case fullName
        case dateOfBirth
        case about

        static var usingKeyboard = allCases
    }

    @StateObject
    var editingCoordinator = EditingCoordinator()

    private let instrument: Instrument
    private let context: StudentDetailsContext

    init(instrument: Instrument, state: ViewState, context: StudentDetailsContext) {
        self.instrument = instrument
        self.state = state
        self.context = context
    }

    // MARK: - Subtitle -
    var subtitle: [MultiStyleText.Part] {
        editingFocus == .none
            ? "Enter the details of the student who will be learning " + instrument.standaloneName.style(.bodyBold)
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
    var dateOfBirthText: String? { state.dateOfBirth.map(Self.dateFormatter.string(from:)) }
    var dateOfBirthPlaceholderText: String { Self.dateFormatter.string(from: dateOfBirthPlaceholder) }

    private static let dateFormatter = Current.dateFormatter(format: .preset(date: .long))
    private let dateOfBirthPlaceholder = Current.date() - Const.averageStudentAge

    // MARK: - About -
    var aboutNameTextPart: MultiStyleText.Part {
        sanitizedName?.firstWord.map { $0.color(.rythmicoPurple) } ?? "Student"
    }

    private var sanitizedAbout: String {
        state.about
            .trimmingLineCharacters(in: .whitespacesAndNewlines)
            .removingRepetitionOf(.whitespace)
            .removingRepetitionOf(.newline)
    }

    // MARK: - Next Button -
    var nextButtonAction: Action? {
        guard
            let name = sanitizedName,
            let dateOfBirth = state.dateOfBirth
        else {
            return nil
        }

        return {
            context.setStudent(
                Student(
                    name: name,
                    dateOfBirth: dateOfBirth,
                    about: sanitizedAbout
                )
            )
        }
    }

    // MARK: - Body -
    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(title: "Student Details", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingLarge) {
                        HeaderContentView(title: "Full Name") {
                            CustomTextField(
                                "Enter Name...",
                                text: $state.name,
                                inputMode: KeyboardInputMode(contentType: .name, autocapitalization: .words),
                                onEditingChanged: fullNameEditingChanged
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                        }
                        HeaderContentView(title: ["Date of Birth".style(.bodyBold)], titleAccessory: {
                            InfoDisclaimerButton(
                                title: "Why Date of Birth?",
                                message: "This gives tutors a better understanding of the learning requirements for each student, and will help to plan their lessons accordingly."
                            ).offset(y: 1)
                        }) {
                            CustomTextField(
                                dateOfBirthPlaceholderText,
                                text: .constant(dateOfBirthText ?? .empty),
                                inputMode: DatePickerInputMode(selection: $state.dateOfBirth.or(dateOfBirthPlaceholder), mode: .date),
                                inputAccessory: .doneButton,
                                onEditingChanged: dateOfBirthEditingChanged
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                        }
                        HeaderContentView(title: "About ".style(.bodyBold) + aboutNameTextPart.style(.bodyBold)) {
                            MultilineTextField(
                                "Existing instrument prowess etc.",
                                text: $state.about,
                                inputAccessory: .none,
                                onEditingChanged: aboutEditingChanged
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                        }
                    }
                    .rythmicoFont(.body)
                    .accentColor(.rythmicoPurple)
                    .padding([.trailing, .bottom], .spacingMedium)
                }
                .padding(.leading, .spacingMedium)

                if let action = nextButtonAction {
                    FloatingView {
                        Button("Next", action: action).primaryStyle()
                    }
                }
            }
            .animation(.rythmicoSpring(duration: .durationShort), value: nextButtonAction != nil)
        }
        .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
        .testable(self)
        .onDisappear(perform: endEditing)
    }

    func fullNameEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .fullName : .none
    }

    func dateOfBirthEditingChanged(_ isEditing: Bool) {
        state.dateOfBirth ??= dateOfBirthPlaceholder
        editingFocus = isEditing ? .dateOfBirth : .none
    }

    func aboutEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .about : .none
    }
}

#if DEBUG
struct StudentDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        let state = StudentDetailsView.ViewState()
        state.name = "David"
        state.dateOfBirth = .stub - (10, .year)
        state.about = "Something"

        return StudentDetailsView(
            instrument: .piano,
            state: state,
            context: RequestLessonPlanContext()
        ).previewDevices()
    }
}
#endif
