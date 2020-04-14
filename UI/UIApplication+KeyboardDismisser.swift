import UIKit

protocol KeyboardDismisser {
    func dismissKeyboard()
}

extension UIApplication: KeyboardDismisser {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

final class KeyboardDismisserSpy: KeyboardDismisser {
    var dismissKeyboardCount = 0

    func dismissKeyboard() {
        dismissKeyboardCount += 1
    }
}
