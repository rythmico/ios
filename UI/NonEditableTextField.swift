import SwiftUIEncore

struct NonEditableTextField: View {
    var placeholder: String
    var text: String?
    var outlined: Bool = true
    var tapAction: Action

    var body: some View {
        if outlined {
            Container(style: .field, content: content)
        } else {
            content()
        }
    }

    private func content() -> some View {
        CustomTextField(
            placeholder,
            text: .constant(text ?? .empty),
            isEditable: false,
            inputMode: .keyboard()
        )
        .onTapGesture(perform: tapAction)
    }
}
