import SwiftUI
import Sugar

protocol StudentDetailsContext {
    func setStudent(_ student: Student)
}

struct StudentDetailsView: View, TestableView {
    private enum Const {
        static let averageStudentAge: (Int, Calendar.Component) = (10, .year)
    }

    final class ViewState: ObservableObject {
        @Published var name = String()
        @Published var dateOfBirth: Date?
        @Published var gender: Gender?
        @Published var about = String()
    }

    @ObservedObject var state: ViewState
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    enum EditingFocus: EditingFocusEnum {
        case textField
        case dateOfBirth
    }

    @ObservedObject
    private var editingCoordinator = EditingCoordinator<EditingFocus>(keyboardDismisser: Current.keyboardDismisser)
    private var editingFocus: EditingFocus? {
        get { editingCoordinator.focus }
        nonmutating set { editingCoordinator.focus = newValue }
    }

    private let instrument: Instrument
    private let context: StudentDetailsContext

    init(instrument: Instrument, state: ViewState, context: StudentDetailsContext) {
        self.instrument = instrument
        self.state = state
        self.context = context
    }

    // MARK: - Subtitle -
    var subtitle: [MultiStyleText.Part] {
        (UIScreen.main.isLarge && !sizeCategory._isAccessibilityCategory) || editingFocus == .none
            ? "Enter the details of the student who will learn " + instrument.name.style(.bodyBold)
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

    private let dateFormatter = Current.dateFormatter(format: .date(.long))
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
            let dateOfBirth = state.dateOfBirth,
            let gender = state.gender
        else {
            return nil
        }

        return {
            context.setStudent(
                Student(
                    name: name,
                    dateOfBirth: dateOfBirth,
                    gender: gender,
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
                                textContentType: .name,
                                autocapitalizationType: .words,
                                onEditingChanged: textFieldEditingChanged
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                        }
                        HeaderContentView(title: "Date of Birth") {
                            CustomTextField(
                                dateOfBirthPlaceholderText,
                                text: .constant(dateOfBirthText ?? .empty),
                                isEditable: false
                            )
                            .modifier(RoundedThinOutlineContainer(padded: false))
                            .onTapGesture(perform: beginEditingDateOfBirth)
                        }
                        HeaderContentView(title: "Gender") {
                            GenderSelectionView(selection: $state.gender)
                        }
                        HeaderContentView(title: "About ".style(.bodyBold) + aboutNameTextPart.style(.bodyBold)) {
                            MultilineTextField(
                                "Existing instrument prowess etc.",
                                text: $state.about,
                                onEditingChanged: textFieldEditingChanged
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                        }
                    }
                    .rythmicoFont(.body)
                    .accentColor(.rythmicoPurple)
                    .padding([.trailing, .bottom], .spacingMedium)
                    .onBackgroundTapGesture(perform: endEditing)
                }
                .padding(.leading, .spacingMedium)

                ZStack(alignment: .bottom) {
                    nextButtonAction.map { action in
                        FloatingView {
                            Button("Next", action: action).primaryStyle()
                        }
                        .zIndex(0)
                    }

                    if editingFocus == .dateOfBirth {
                        FloatingInputView(doneAction: endEditing) {
                            LabelessDatePicker(
                                selection: Binding(
                                    get: { state.dateOfBirth ?? dateOfBirthPlaceholder },
                                    set: { state.dateOfBirth = $0 }
                                )
                            )
                        }
                        .zIndex(1)
                    }
                }
            }
            .animation(.rythmicoSpring(duration: .durationShort), value: nextButtonAction != nil)
        }
        .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
        .testable(self)
        .onDisappear(perform: endEditing)
    }

    func textFieldEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .textField : .none
    }

    func beginEditingDateOfBirth() {
        editingFocus = .dateOfBirth

        // set date of birth to initial value on first edit
        if state.dateOfBirth == nil {
            state.dateOfBirth = dateOfBirthPlaceholder
        }
    }

    func endEditing() {
        editingFocus = .none
    }
}

#if DEBUG
struct StudentDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        let state = StudentDetailsView.ViewState()
        state.name = "David"
        state.dateOfBirth = .stub - (10, .year)
        state.gender = .male
        state.about = "Something"

        return StudentDetailsView(
            instrument: .piano,
            state: state,
            context: RequestLessonPlanContext()
        ).previewDevices()
    }
}
#endif
