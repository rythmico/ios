import SwiftUI

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var onEditingChanged: (Bool) -> Void
    var onCommit: () -> Void

    init(
        _ placeholder: Text,
        text: Binding<String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: onEditingChanged, onCommit: onCommit)
        }
    }
}
