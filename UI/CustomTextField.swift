import SwiftUI

struct CustomTextField: UIViewRepresentable {
    enum InputAccessory {
        case doneButton
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var onEditingChanged: (Bool) -> Void
        var onCommit: () -> Void

        init(
            text: Binding<String>,
            onEditingChanged: @escaping (Bool) -> Void,
            onCommit: @escaping () -> Void
        ) {
            _text = text
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            onCommit()
            return true
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            onEditingChanged(true)
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            onEditingChanged(false)
        }
    }

    var placeholder: String
    @Binding var text: String
    var isEditable: Bool
    var inputMode: CustomTextFieldInputMode
    var inputAccessory: InputAccessory?
    var onEditingChanged: (Bool) -> Void
    var onCommit: () -> Void

    init(
        _ placeholder: String,
        text: Binding<String>,
        isEditable: Bool = true,
        inputMode: CustomTextFieldInputMode = KeyboardInputMode(),
        inputAccessory: InputAccessory? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isEditable = isEditable
        self.inputMode = inputMode
        self.inputAccessory = inputAccessory
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = CustomUITextField(frame: .zero)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.rythmicoGray30,
                .font: UIFont.rythmicoFont(.body)
            ]
        )
        textField.font = .rythmicoFont(.body)
        textField.isUserInteractionEnabled = isEditable
        textField.inputView = inputMode.inputView(textField: textField)
        textField.inputAccessoryView = inputAccessory.map {
            switch $0 {
            case .doneButton: return UIToolbar.dismissKeyboardTooltip(color: .rythmicoPurple)
            }
        }
        textField.delegate = context.coordinator
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return textField
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, onEditingChanged: onEditingChanged, onCommit: onCommit)
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.rythmicoGray30,
                .font: UIFont.rythmicoFont(.body)
            ]
        )
        uiView.text = text
        uiView.font = .rythmicoFont(.body)
    }
}

private final class CustomUITextField: UITextField {
    private let padding = UIEdgeInsets(
        top: 15,
        left: .spacingSmall,
        bottom: 15,
        right: .spacingSmall
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
