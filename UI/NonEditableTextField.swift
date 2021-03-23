import SwiftUI
import FoundationSugar

struct NonEditableTextField: View {
    var placeholder: String
    var text: String?
    var outlined: Bool = true
    var tapAction: Action

    var body: some View {
        if outlined {
            content.modifier(RoundedThinOutlineContainer(padded: false))
        } else {
            content
        }
    }

    private var content: some View {
        CustomTextField(
            placeholder,
            text: .constant(text ?? .empty),
            isEditable: false
        )
        .onTapGesture(perform: tapAction)
    }
}
