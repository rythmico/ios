import SwiftUISugar

struct PrivateNoteView: View, FocusableView, TestableView {
    @ObservedObject
    var state: ViewState
    var setter: Binding<String>.Setter

    enum Focus: FocusEnum, CaseIterable {
        case privateNote

        static var usingKeyboard = allCases
    }

    @StateObject
    var focusCoordinator = FocusCoordinator(keyboardDismisser: Current.keyboardDismisser)

    final class ViewState: ObservableObject {
        @Published var privateNote: String = ""
    }

    private var subtitle: Text? {
        focus == .none
            ? Text("Enter details of what you're looking for to make it easier for prospective tutors")
            : nil
    }

    @SpacedTextBuilder
    private var privateNoteHeaderTitle: Text {
        "Private Note"
        "(optional)".text.rythmicoFontWeight(.body)
    }

    var nextButtonAction: Action {
        {
            setter(
                state.privateNote
                    .trimmingLineCharacters(in: .whitespacesAndNewlines)
                    .removingRepetitionOf(.whitespace)
                    .removingRepetitionOf(.newline)
            )
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(title: "Private Note", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView {
                    HeaderContentView(title: privateNoteHeaderTitle) {
                        Container(style: .field) {
                            MultilineTextField(
                                "Message prospective tutors...",
                                text: $state.privateNote,
                                inputAccessory: .none,
                                minHeight: 120,
                                onEditingChanged: noteEditingChanged
                            )
                        }
                    }
                    .frame(maxWidth: .grid(.max))
                    .padding([.trailing, .bottom], .grid(5))
                }
                .accentColor(.rythmico.picoteeBlue)
                .padding(.leading, .grid(5))

                FloatingView {
                    RythmicoButton("Next", style: RythmicoButtonStyle.primary(), action: nextButtonAction)
                }
            }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: focus)
        .testable(self)
        .onDisappear(perform: endEditing)
    }

    func noteEditingChanged(_ isEditing: Bool) {
        focus = isEditing ? .privateNote : .none
    }
}

#if DEBUG
struct PrivateNoteView_Previews: PreviewProvider {
    static var previews: some View {
        let state = PrivateNoteView.ViewState()
        state.privateNote = "Note"

        return PrivateNoteView(
            state: state,
            setter: { _ in }
        )
        .previewDevices()
    }
}
#endif
