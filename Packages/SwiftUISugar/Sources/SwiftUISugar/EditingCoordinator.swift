public protocol EditingFocusEnum: Equatable {
    static var usingKeyboard: [Self] { get }
}

extension EditingFocusEnum {
    var usesKeyboard: Bool {
        Self.usingKeyboard.contains(self)
    }
}

public final class EditingCoordinator<Focus: EditingFocusEnum>: ObservableObject {
    @Published public var focus: Focus? = .none {
        willSet {
            let shouldDismissKeyboard: Bool

            switch (focus, newValue) {
            case let (oldFocus?, newFocus?):
                shouldDismissKeyboard = oldFocus.usesKeyboard && !newFocus.usesKeyboard
            case let (oldFocus?, .none):
                shouldDismissKeyboard = oldFocus.usesKeyboard
            case (.none, _):
                shouldDismissKeyboard = false
            }

            if shouldDismissKeyboard {
                keyboardDismisser.dismissKeyboard()
            }
        }
    }

    private let keyboardDismisser: KeyboardDismisser

    public init(
        keyboardDismisser: KeyboardDismisser,
        endEditingOnBackgroundTap: Bool = true
    ) {
        self.keyboardDismisser = keyboardDismisser

        if endEditingOnBackgroundTap {
            UIApplication.shared.onBackgroundTap { [weak self] in self?.endEditing() }
        }
    }

    public func endEditing() {
        focus = .none
    }
}
