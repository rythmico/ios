import SwiftUISugar

extension UIToolbar {
    static func dismissKeyboardTooltip(color: UIColor) -> UIToolbar {
        UIToolbar().then {
            $0.sizeToFit()
            $0.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(
                    systemItem: .done,
                    primaryAction: UIAction { _ in Current.keyboardDismisser.dismissKeyboard() },
                    menu: nil
                ).then {
                    $0.tintColor = color
                }
            ]
        }
    }
}
