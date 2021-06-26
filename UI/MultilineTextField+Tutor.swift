import SwiftUISugar

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
            attributes: [.paragraphStyle: NSMutableParagraphStyle().with(\.paragraphSpacing, .grid(4))],
            accentColor: nil,
            placeholderColor: nil,
            inputAccessory: inputAccessory,
            minHeight: minHeight,
            padding: .zero,
            onEditingChanged: onEditingChanged
        )
    }
}
