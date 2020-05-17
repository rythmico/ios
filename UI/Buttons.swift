import SwiftUI
import Sugar

extension Button {
    func primaryStyle() -> some View {
        buttonStyle(PrimaryButtonStyle())
    }

    func secondaryStyle() -> some View {
        buttonStyle(SecondaryButtonStyle())
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

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .rythmicoFont(.callout)
            .foregroundColor(foregroundColor(for: configuration))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.rythmicoGray30, lineWidth: 2)
            )
            .background(
                backgroundColor(for: configuration).cornerRadius(4)
            )
    }

    func foregroundColor(for configuration: Configuration) -> Color {
        configuration.isPressed
            ? Color.rythmicoWhite
            : Color.rythmicoGray90
    }

    func backgroundColor(for configuration: Configuration) -> Color {
        configuration.isPressed
            ? Color.rythmicoGray30
            : Color.clear
    }
}
