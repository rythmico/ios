import SwiftUI

struct TextFieldViewData {
    var placeholder: String
    var text: Binding<String>
    var onEditingChanged: (Bool) -> Void
}

extension TextField where Label == Text {
    init(_ viewData: TextFieldViewData) {
        self.init(viewData.placeholder, text: viewData.text, onEditingChanged: viewData.onEditingChanged)
    }
}
