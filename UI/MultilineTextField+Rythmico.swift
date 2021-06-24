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
            attributes: .rythmicoTextAttributes(color: .rythmicoForeground, style: .body),
            accentColor: .rythmicoPurple,
            placeholderColor: .rythmicoGray30,
            inputAccessory: inputAccessory,
            minHeight: minHeight,
            padding: EdgeInsets(horizontal: .grid(4), vertical: 15),
            onEditingChanged: onEditingChanged
        )
    }
}
