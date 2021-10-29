import StudentDTO
import SwiftUIEncore

struct StudentDetailsView: View, FocusableView, TestableView {
    private enum Const {
        static let averageStudentAge: (Int, Calendar.Component) = (10, .year)
    }

    enum Focus: FocusEnum, CaseIterable {
        case fullName
        case dateOfBirth
        case about

        static var usingKeyboard = allCases
    }

    @StateObject
    var focusCoordinator = FocusCoordinator(keyboardDismisser: Current.keyboardDismisser)

    final class ViewState: ObservableObject {
        @Published var name = String()
        @Published var dateOfBirth: DateOnly?
        @Published var about = String()
    }

    var instrument: Instrument
    @ObservedObject
    var state: ViewState
    var setter: Binding<Student>.Setter

    // MARK: - Subtitle -
    var subtitle: Text? {
        focus == .none
            ? Text(separator: .whitespace) {
                "Enter the details of the student who will be learning"
                instrument.standaloneName.text.rythmicoFontWeight(.subheadlineMedium)
            }
            : nil
    }

    // MARK: - Name -
    private var sanitizedName: String? {
        state.name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .removingRepetition(of: .whitespace)
            .removingAll(of: .newline)
            .nilIfEmpty
    }

    // MARK: - Date of Birth -
    var dateOfBirthText: String? { state.dateOfBirth?.formatted(style: .long, locale: Current.locale()) }
    var dateOfBirthPlaceholderText: String { dateOfBirthPlaceholder.formatted(style: .long, locale: Current.locale()) }

    private let dateOfBirthPlaceholder = try! Current.dateOnly() - Const.averageStudentAge

    // MARK: - About -
    @SpacedTextBuilder
    var aboutHeaderTitle: Text {
        "About"
        if let firstName = sanitizedName?.firstWord {
            firstName.text.foregroundColor(.rythmico.picoteeBlue)
        } else {
            "Student"
        }
    }

    private var sanitizedAbout: String {
        state.about
            .trimmingLineCharacters(in: .whitespacesAndNewlines)
            .removingRepetition(of: .whitespace)
            .removingRepetition(of: .newline)
    }

    // MARK: - Next Button -
    var nextButtonAction: Action? {
        unwrap(sanitizedName, state.dateOfBirth, sanitizedAbout).map(Student.init).mapToAction(setter)
    }

    // MARK: - Body -
    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView("Student Details", subtitle) { padding in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .grid(5)) {
                        TextFieldHeader("Full Name") {
                            Container(style: .field) {
                                CustomTextField(
                                    "Enter Name...",
                                    text: $state.name,
                                    inputMode: KeyboardInputMode(contentType: .name, autocapitalization: .words),
                                    onEditingChanged: fullNameEditingChanged
                                )
                            }
                        }
                        TextFieldHeader("Date of Birth", accessory: {
                            InfoDisclaimerButton(
                                title: "Why Date of Birth?",
                                message: "This gives tutors a better understanding of the learning requirements for each student, and will help to plan their lessons accordingly."
                            )
                        }) {
                            Container(style: .field) {
                                CustomTextField(
                                    dateOfBirthPlaceholderText,
                                    text: .constant(dateOfBirthText ?? .empty),
                                    inputMode: DateOnlyPickerInputMode(selection: $state.dateOfBirth.or(dateOfBirthPlaceholder)),
                                    inputAccessory: .doneButton,
                                    onEditingChanged: dateOfBirthEditingChanged
                                )
                            }
                        }
                        TextFieldHeader(aboutHeaderTitle) {
                            Container(style: .field) {
                                MultilineTextField(
                                    "Existing instrument prowess etc.",
                                    text: $state.about,
                                    inputAccessory: .none,
                                    onEditingChanged: aboutEditingChanged
                                )
                            }
                        }
                    }
                    .accentColor(.rythmico.picoteeBlue)
                    .frame(maxWidth: .grid(.max))
                    .padding([.trailing, .bottom], padding.trailing)
                }
                .padding(.leading, padding.leading)

                if let action = nextButtonAction {
                    FloatingView {
                        RythmicoButton("Next", style: .primary(), action: action)
                    }
                }
            }
            .animation(.rythmicoSpring(duration: .durationShort), value: nextButtonAction != nil)
        }
        .animation(.easeInOut(duration: .durationMedium), value: focus)
        .testable(self)
        .onDisappear(perform: endEditing)
    }

    func fullNameEditingChanged(_ isEditing: Bool) {
        focus = isEditing ? .fullName : .none
    }

    func dateOfBirthEditingChanged(_ isEditing: Bool) {
        state.dateOfBirth =?? dateOfBirthPlaceholder
        focus = isEditing ? .dateOfBirth : .none
    }

    func aboutEditingChanged(_ isEditing: Bool) {
        focus = isEditing ? .about : .none
    }
}

#if DEBUG
struct StudentDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        let state = StudentDetailsView.ViewState()
        state.name = "David"
        state.dateOfBirth = try! .stub - (10, .year)
        state.about = "Something"

        return StudentDetailsView(
            instrument: .piano,
            state: state,
            setter: { _ in }
        ).previewDevices()
    }
}
#endif
