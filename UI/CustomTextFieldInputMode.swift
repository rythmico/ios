import SwiftUI

protocol CustomTextFieldInputMode {
    func inputView(textField: UITextField) -> UIView?
}

struct KeyboardInputMode: CustomTextFieldInputMode {
    var contentType: UITextContentType? = nil
    var autocapitalization: UITextAutocapitalizationType = .none
    var returnKey: UIReturnKeyType = .done

    func inputView(textField: UITextField) -> UIView? {
        textField.textContentType = contentType
        textField.autocapitalizationType = autocapitalization
        textField.returnKeyType = returnKey
        return nil
    }
}
