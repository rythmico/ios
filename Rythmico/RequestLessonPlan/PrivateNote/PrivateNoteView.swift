import SwiftUI
import Sugar

protocol PrivateNoteContext {
    func setPrivateNote(_ note: String)
}

struct PrivateNoteView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var privateNote: String = ""
    }

    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    @ObservedObject
    private var state: ViewState
    private let context: PrivateNoteContext

    enum EditingFocus: EditingFocusEnum {
        // TODO: remove with Swift 5.3
        static var none: Self { ._none }
        static var textField: Self { ._textField }
        var isNone: Bool { is_none }
        var isTextField: Bool { is_textField }
        case _none
        case _textField
    }

    @ObservedObject
    private var editingCoordinator = EditingCoordinator<EditingFocus>(keyboardDismisser: Current.keyboardDismisser)
    private(set) var editingFocus: EditingFocus {
        get { editingCoordinator.focus }
        nonmutating set { editingCoordinator.focus = newValue }
    }

    init(state: ViewState, context: PrivateNoteContext) {
        self.state = state
        self.context = context
    }

    private var subtitle: [MultiStyleText.Part] {
        (UIScreen.main.isLarge && !sizeCategory._isAccessibilityCategory) || editingFocus.isNone
            ? ["Enter details of what you're looking for to make it easier for prospective tutors"]
            : .empty
    }

    var nextButtonAction: Action {
        {
            self.context.setPrivateNote(
                self.state.privateNote
                    .trimmingLineCharacters(in: .whitespacesAndNewlines)
                    .removingRepetitionOf(.whitespace)
                    .removingRepetitionOf(.newline)
            )
        }
    }

    var onAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Private Note", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView {
                    HeaderContentView(title: "Private Note".style(.bodyBold) + " (optional)") {
                        MultilineTextField(
                            "Message prospective tutors...",
                            text: $state.privateNote,
                            minHeight: 120,
                            onEditingChanged: noteEditingChanged
                        )
                        .modifier(RoundedThinOutlineContainer(padded: false))
                    }
                    .onBackgroundTapGesture(perform: endEditing)
                    .padding([.trailing, .bottom], .spacingMedium)
                }
                .avoidingKeyboard()
                .padding(.leading, .spacingMedium)

                FloatingView {
                    Button("Next", action: nextButtonAction).primaryStyle()
                }
            }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: editingFocus)
        .onAppear { self.onAppear?(self) }
        .onDisappear(perform: endEditing)
    }

    func noteEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .textField : .none
    }

    func endEditing() {
        editingFocus = .none
    }
}

#if DEBUG
struct PrivateNoteView_Previews: PreviewProvider {
    static var previews: some View {
        let state = PrivateNoteView.ViewState()
        state.privateNote = "Note"

        return PrivateNoteView(
            state: state,
            context: RequestLessonPlanContext()
        )
        .previewDevices()
    }
}
#endif
