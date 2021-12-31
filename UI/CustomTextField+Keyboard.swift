import SwiftUIEncore

// MARK: - Keyboard -

struct KeyboardInputMode: CustomTextFieldInputMode {
    var contentType: UITextContentType? = nil
    var autocapitalization: UITextAutocapitalizationType = .none
    var returnKey: UIReturnKeyType = .done

    func view(for textField: UITextField) -> UIView? {
        textField.textContentType = contentType
        textField.autocapitalizationType = autocapitalization
        textField.returnKeyType = returnKey
        return nil
    }
}

extension CustomTextFieldInputMode where Self == KeyboardInputMode {
    static func keyboard(
        contentType: UITextContentType? = nil,
        autocapitalization: UITextAutocapitalizationType = .none,
        returnKey: UIReturnKeyType = .done
    ) -> KeyboardInputMode {
        KeyboardInputMode(contentType: contentType, autocapitalization: autocapitalization, returnKey: returnKey)
    }
}
