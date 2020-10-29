import UIKit
import Then

extension UIToolbar {
    static func dismissKeyboardTooltip(withFont font: UIFont, color: UIColor) -> UIToolbar {
        UIToolbar().then {
            $0.sizeToFit()
            $0.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(
                    customView: UIButton().then {
                        if let font = font.fontDescriptor
                            .withSymbolicTraits(.traitBold)
                            .map ({ UIFont(descriptor: $0, size: $0.pointSize + 2) })
                        {
                            $0.setPreferredSymbolConfiguration(.init(font: font), forImageIn: .normal)
                        }
                        $0.setImage(.keyboardChevronCompactDown, for: .normal)
                        $0.tintColor = color
                        $0.addAction(
                            UIAction { _ in Current.keyboardDismisser.dismissKeyboard() },
                            for: .touchUpInside
                        )
                    }
                )
            ]
        }
    }
}
