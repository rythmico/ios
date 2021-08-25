import SwiftUIEncore

extension UIToolbar {
    static func dismissKeyboardTooltip(color: UIColor) -> UIToolbar {
        UIToolbar() => {
            $0.sizeToFit()
            $0.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(
                    systemItem: .done,
                    primaryAction: UIAction { _ in Current.keyboardDismisser.dismissKeyboard() },
                    menu: nil
                ) => {
                    $0.tintColor = color
                }
            ]
        }
    }
}
