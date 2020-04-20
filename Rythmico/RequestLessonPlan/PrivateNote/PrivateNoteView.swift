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
    private var editingCoordinator: EditingCoordinator<EditingFocus>
    private(set) var editingFocus: EditingFocus {
        get { editingCoordinator.focus }
        nonmutating set { editingCoordinator.focus = newValue }
    }

    init(
        state: ViewState,
        context: PrivateNoteContext,
        keyboardDismisser: KeyboardDismisser
    ) {
        self.state = state
        self.context = context
        self.editingCoordinator = EditingCoordinator(keyboardDismisser: keyboardDismisser)
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

    var didAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Private Note", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView {
                    TitleContentView(title: "Private Note".bold + " (optional)", style: .body) {
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
        .onAppear { self.didAppear?(self) }
    }

    func noteEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .textField : .none
    }

    func endEditing() {
        editingFocus = .none
    }
}

struct PrivateNoteView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateNoteView(
            state: .init(),
            context: RequestLessonPlanContext(),
            keyboardDismisser: UIApplication.shared
        )
        .previewDevices()
    }
}
