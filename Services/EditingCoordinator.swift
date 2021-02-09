import Foundation

protocol EditingFocusEnum: Equatable {
    static var textField: Self { get }
}

final class EditingCoordinator<Focus: EditingFocusEnum>: ObservableObject {
    @Published var focus: Focus? = .none {
        willSet {
            if focus == .textField, newValue != .textField {
                keyboardDismisser.dismissKeyboard()
            }
        }
    }

    private let keyboardDismisser: KeyboardDismisser

    init(
        keyboardDismisser: KeyboardDismisser,
        endEditingOnBackgroundTap: Bool = true
    ) {
        self.keyboardDismisser = keyboardDismisser

        if endEditingOnBackgroundTap {
            UIApplication.shared.onBackgroundTap { [weak self] in self?.endEditing() }
        }
    }

    func endEditing() {
        focus = .none
    }
}
