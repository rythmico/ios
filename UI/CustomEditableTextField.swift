import SwiftUISugar

struct CustomEditableTextField<EditingView: View>: View {
    var placeholder: String
    var text: String?
    var isEditing: Bool = false
    var editAction: Action
    @ViewBuilder
    var editingView: EditingView

    @Namespace
    private var animation

    var body: some View {
        Container(style: .field) {
            switch isEditing {
            case false:
                textField.matchedGeometryEffect(id: animation, in: animation, properties: .size)
            case true:
                editingView.matchedGeometryEffect(id: animation, in: animation, properties: .size)
            }
        }
    }

    private var textField: some View {
        NonEditableTextField(
            placeholder: placeholder,
            text: text,
            outlined: false,
            tapAction: editAction
        )
    }
}
