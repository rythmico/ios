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
        @Published var about = String()
    }

    @ObservedObject var state: ViewState

    enum EditingFocus: EditingFocusEnum {
        case textField
        case dateOfBirth
    }

    @StateObject
    private var editingCoordinator = EditingCoordinator<EditingFocus>(keyboardDismisser: Current.keyboardDismisser)
    private var editingFocus: EditingFocus? {
        get { editingCoordinator.focus }
        nonmutating set { editingCoordinator.focus = newValue }
    }

    @State
    private var showingDateOfBirthPrivacyInfo = false

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
    var dateOfBirthText: String? { state.dateOfBirth.map(dateFormatter.string(from:)) }
    var dateOfBirthPlaceholderText: String { dateFormatter.string(from: dateOfBirthPlaceholder) }

    private let dateFormatter = Current.dateFormatter(format: .preset(date: .long))
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
                                textContentType: .name,
                                autocapitalizationType: .words,
                                onEditingChanged: textFieldEditingChanged
                            ).modifier(RoundedThinOutlineContainer(padded: false))
                        }
                        HeaderContentView(title: ["Date of Birth".style(.bodyBold)], titleAccessory: {
                            Image(decorative: Asset.iconInfo.name)
                                .renderingMode(.template)
                                .foregroundColor(.rythmicoGray90)
                                .alert(isPresented: $showingDateOfBirthPrivacyInfo) {
                                    Alert(
                                        title: Text("Why Date of Birth?"),
                                        message: Text("This allows tutors to better understand the learning requirements of the student and how to structure lessons for the most comprehensive learning and enjoyment.")
                                    )
                                }
                                .onTapGesture(perform: showDateOfBirthPrivacyInfo)
                        }) {
                            CustomTextField(
                                dateOfBirthPlaceholderText,
                                text: .constant(dateOfBirthText ?? .empty),
                                isEditable: false
                            )
                            .modifier(RoundedThinOutlineContainer(padded: false))
                            .onTapGesture(perform: beginEditingDateOfBirth)
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

    func showDateOfBirthPrivacyInfo() {
        showingDateOfBirthPrivacyInfo = true
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
