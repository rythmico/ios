import Foundation

protocol EditingFocusEnum: Equatable {
    static var none: Self { get }
    static var textField: Self { get }
}

final class EditingCoordinator<Focus: EditingFocusEnum>: ObservableObject {
    @Published var focus: Focus = .none {
        willSet {
            if focus == .textField, newValue != .textField {
                keyboardDismisser.dismissKeyboard()
            }
        }
    }

    private let keyboardDismisser: KeyboardDismisser

    init(keyboardDismisser: KeyboardDismisser) {
        self.keyboardDismisser = keyboardDismisser
    }
}
