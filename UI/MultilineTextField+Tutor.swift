import SwiftUI

extension MultilineTextField {
    init(
        _ placeholder: String = "",
        text: Binding<String>,
        inputAccessory: CustomTextFieldInputAccessory?,
        minHeight: CGFloat? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self.init(
            placeholder,
            text: text,
            font: nil,
            accentColor: nil,
            textColor: nil,
            placeholderColor: nil,
            inputAccessory: inputAccessory,
            minHeight: minHeight,
            padding: .zero,
            onEditingChanged: onEditingChanged
        )
    }
}
