import SwiftUI
import Sugar

extension Button {
    init<LabelModifier: ViewModifier>(
        _ title: String,
        style: LabelModifier,
        action: @escaping Action
    ) where Label == ModifiedContent<AnyView, LabelModifier> {
        self.init(action: action) {
            AnyView(Text(title)).modifier(style)
        }
    }
}

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rythmicoFont(.callout)
            .foregroundColor(.rythmicoWhite)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color.rythmicoPurple.cornerRadius(4))
    }
}
