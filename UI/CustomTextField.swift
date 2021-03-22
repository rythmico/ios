import SwiftUI

struct CustomTextField: UIViewRepresentable {
    enum InputMode {
        case keyboard(
                contentType: UITextContentType? = nil,
                autocapitalization: UITextAutocapitalizationType = .none,
                returnKey: UIReturnKeyType = .done
             )
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
    var inputMode: InputMode
    var onEditingChanged: (Bool) -> Void
    var onCommit: () -> Void

    init(
        _ placeholder: String,
        text: Binding<String>,
        isEditable: Bool = true,
        inputMode: InputMode = .keyboard(),
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isEditable = isEditable
        self.inputMode = inputMode
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
        switch inputMode {
        case let .keyboard(contentType, autocapitalization, returnKey):
            textField.textContentType = contentType
            textField.autocapitalizationType = autocapitalization
            textField.returnKeyType = returnKey
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
