import SwiftUI
import TextBuilder
import FoundationSugar

struct PrivateNoteView: View, EditableView, TestableView {
    final class ViewState: ObservableObject {
        @Published var privateNote: String = ""
    }

    @ObservedObject
    var state: ViewState
    var setter: Binding<String>.Setter

    enum EditingFocus: EditingFocusEnum, CaseIterable {
        case privateNote

        static var usingKeyboard = allCases
    }

    @StateObject
    var editingCoordinator = EditingCoordinator()

    private var subtitle: Text? {
        editingFocus == .none
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
                        MultilineTextField(
                            "Message prospective tutors...",
                            text: $state.privateNote,
                            inputAccessory: .none,
                            minHeight: 120,
                            onEditingChanged: noteEditingChanged
                        ).modifier(RoundedThinOutlineContainer(padded: false))
                    }
                    .frame(maxWidth: .spacingMax)
                    .padding([.trailing, .bottom], .spacingMedium)
                }
                .accentColor(.rythmicoPurple)
                .padding(.leading, .spacingMedium)

                FloatingView {
                    RythmicoButton("Next", style: RythmicoButtonStyle.primary(), action: nextButtonAction)
                }
            }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: editingFocus)
        .testable(self)
        .onDisappear(perform: endEditing)
    }

    func noteEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .privateNote : .none
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
