import SwiftUI

enum CustomTextFieldInputAccessory: Equatable {
    case doneButton

    func view(accentColor: UIColor) -> UIToolbar? {
        switch self {
        case .doneButton:
            return .dismissKeyboardTooltip(color: accentColor)
        }
    }
}
