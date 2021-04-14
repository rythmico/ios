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
            textStyle: .body,
            accentColor: .rythmicoPurple,
            textColor: .rythmicoForeground,
            placeholderColor: .rythmicoGray30,
            inputAccessory: inputAccessory,
            minHeight: minHeight,
            padding: EdgeInsets(horizontal: .spacingSmall, vertical: 15),
            onEditingChanged: onEditingChanged
        )
    }
}
