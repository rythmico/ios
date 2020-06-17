import SwiftUI
import Sugar

extension Button {
    func primaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(PrimaryButtonStyle(expansive: expansive))
    }

    func secondaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(SecondaryButtonStyle(expansive: expansive))
    }

    func tertiaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(TertiaryButtonStyle(expansive: expansive))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var expansive: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, .spacingMedium)
            .rythmicoFont(.bodyBold)
            .foregroundColor(.rythmicoWhite)
            .frame(maxWidth: expansive ? .infinity : nil, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(backgroundColor(for: configuration))
            )
    }

    func backgroundColor(for configuration: Configuration) -> Color {
        configuration.isPressed
            ? Color.rythmicoHighlightPurple
            : Color.rythmicoPurple
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var expansive: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, .spacingMedium)
            .rythmicoFont(.bodyBold)
            .foregroundColor(foregroundColor(for: configuration))
            .frame(maxWidth: expansive ? .infinity : nil, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(backgroundColor(for: configuration))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(Color.rythmicoPurple, lineWidth: 2)
                    )
                    .contentShape(Rectangle())
            )
    }

    func foregroundColor(for configuration: Configuration) -> Color {
        configuration.isPressed
            ? Color.rythmicoWhite
            : Color.rythmicoPurple
    }

    func backgroundColor(for configuration: Configuration) -> Color {
        configuration.isPressed
            ? Color.rythmicoPurple
            : Color.clear
    }
}

struct TertiaryButtonStyle: ButtonStyle {
    var expansive: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, .spacingMedium)
            .rythmicoFont(.bodyBold)
            .foregroundColor(foregroundColor(for: configuration))
            .frame(maxWidth: expansive ? .infinity : nil, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(backgroundColor(for: configuration))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(Color.rythmicoGray30, lineWidth: 2)
                    )
                    .contentShape(Rectangle())
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

#if DEBUG
struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Button("Next", action: {}).primaryStyle()
            Button("Next", action: {}).primaryStyle(expansive: false)

            Button("Next", action: {}).secondaryStyle()
            Button("Next", action: {}).secondaryStyle(expansive: false)

            Button("Next", action: {}).tertiaryStyle()
            Button("Next", action: {}).tertiaryStyle(expansive: false)
        }
        .padding()
    }
}
#endif
