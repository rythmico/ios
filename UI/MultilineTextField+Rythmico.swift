import SwiftUI

extension MultilineTextField {
    init(
        _ placeholder: String = "",
        text: Binding<String>,
        minHeight: CGFloat? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self.init(
            placeholder,
            text: text,
            font: .rythmicoFont(.body),
            accentColor: .rythmicoPurple,
            textColor: .rythmicoForeground,
            placeholderColor: .rythmicoGray30,
            minHeight: minHeight,
            padding: EdgeInsets(horizontal: .spacingSmall, vertical: 15),
            onEditingChanged: onEditingChanged
        )
    }
}
