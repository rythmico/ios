import SwiftUI
import Sugar

extension Button {
    func primaryStyle() -> some View {
        buttonStyle(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .rythmicoFont(.callout)
            .foregroundColor(.rythmicoWhite)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(backgroundColor(for: configuration).cornerRadius(4))
    }

    func backgroundColor(for configuration: Configuration) -> Color {
        configuration.isPressed
            ? Color.rythmicoHighlightPurple
            : Color.rythmicoPurple
    }
}
