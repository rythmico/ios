import SwiftUISugar

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
        @Published var dateOfBirth: Date?
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
                instrument.standaloneName.text.rythmicoFontWeight(.bodyBold)
            }
            : nil
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
            setter(
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
                    VStack(alignment: .leading, spacing: .grid(6)) {
                        HeaderContentView(title: "Full Name") {
                            Container(style: .field) {
                                CustomTextField(
                                    "Enter Name...",
                                    text: $state.name,
                                    inputMode: KeyboardInputMode(contentType: .name, autocapitalization: .words),
                                    onEditingChanged: fullNameEditingChanged
                                )
                            }
                        }
                        HeaderContentView(title: "Date of Birth", titleAccessory: {
                            InfoDisclaimerButton(
                                title: "Why Date of Birth?",
                                message: "This gives tutors a better understanding of the learning requirements for each student, and will help to plan their lessons accordingly."
                            )
                        }) {
                            Container(style: .field) {
                                CustomTextField(
                                    dateOfBirthPlaceholderText,
                                    text: .constant(dateOfBirthText ?? .empty),
                                    inputMode: DatePickerInputMode(selection: $state.dateOfBirth.or(dateOfBirthPlaceholder), mode: .date),
                                    inputAccessory: .doneButton,
                                    onEditingChanged: dateOfBirthEditingChanged
                                )
                            }
                        }
                        HeaderContentView(title: aboutHeaderTitle) {
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
                    .padding([.trailing, .bottom], .grid(5))
                }
                .padding(.leading, .grid(5))

                if let action = nextButtonAction {
                    FloatingView {
                        RythmicoButton("Next", style: RythmicoButtonStyle.primary(), action: action)
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
        state.dateOfBirth ??= dateOfBirthPlaceholder
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
        state.dateOfBirth = .stub - (10, .year)
        state.about = "Something"

        return StudentDetailsView(
            instrument: .piano,
            state: state,
            setter: { _ in }
        ).previewDevices()
    }
}
#endif
