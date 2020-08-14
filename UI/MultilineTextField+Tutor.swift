import SwiftUI

extension MultilineTextField {
    init(
        _ placeholder: String = "",
        text: Binding<String>,
        minHeight: CGFloat? = nil,
        onEditingChanged: @escaping (Bool) -> Void
    ) {
        self.init(
            placeholder,
            text: text,
            font: nil,
            accentColor: nil,
            textColor: nil,
            placeholderColor: nil,
            minHeight: minHeight,
            onEditingChanged: onEditingChanged
        )
    }
}
