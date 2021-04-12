import SwiftUI
import FoundationSugar

extension Button {
    func primaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(
            RythmicoButtonStyle(
                expansive: expansive,
                foregroundColor: (normal: .rythmicoWhite, pressed: .rythmicoWhite),
                backgroundColor: (normal: .rythmicoPurple, pressed: .rythmicoHighlightPurple),
                borderColor: (normal: .clear, pressed: .clear)
            )
        )
    }

    func secondaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(
            RythmicoButtonStyle(
                expansive: expansive,
                foregroundColor: (normal: .rythmicoPurple, pressed: .rythmicoWhite),
                backgroundColor: (normal: .clear, pressed: .rythmicoPurple),
                borderColor: (normal: .rythmicoPurple, pressed: .rythmicoPurple)
            )
        )
    }

    func tertiaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(
            RythmicoButtonStyle(
                expansive: expansive,
                foregroundColor: (normal: .rythmicoGray90, pressed: .rythmicoWhite),
                backgroundColor: (normal: .clear, pressed: .rythmicoGray30),
                borderColor: (normal: .rythmicoGray30, pressed: .rythmicoGray30)
            )
        )
    }

    func quaternaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(RythmicoLinkButtonStyle(expansive: expansive))
    }
}

private struct RythmicoButtonStyle: ButtonStyle {
    typealias StateColors = (normal: Color, pressed: Color)

    var expansive: Bool
    let buttonMaxWidth = .spacingUnit * 85
    var foregroundColor: StateColors
    var backgroundColor: StateColors
    var borderColor: StateColors

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, .spacingMedium)
            .rythmicoFont(.bodyBold)
            .foregroundColor(color(from: foregroundColor, for: configuration))
            .frame(maxWidth: expansive ? buttonMaxWidth : nil, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(color(from: backgroundColor, for: configuration))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(color(from: borderColor, for: configuration), lineWidth: 2)
                    )
                    .contentShape(Rectangle())
            )
            .modifier(DiseableableButtonModifier())
    }

    func color(from colors: StateColors, for configuration: Configuration) -> Color {
        configuration.isPressed ? colors.pressed : colors.normal
    }
}

private struct RythmicoLinkButtonStyle: ButtonStyle {
    var expansive: Bool
    let buttonMaxWidth = .spacingUnit * 85

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.rythmicoGray90)
            .rythmicoFont(.body)
            .opacity(configuration.isPressed ? 0.3 : 1)
            .frame(maxWidth: expansive ? buttonMaxWidth : nil, minHeight: 48)
            .modifier(DiseableableButtonModifier())
            .contentShape(Rectangle())
    }
}

private struct DiseableableButtonModifier: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isEnabled ? 1 : 0.3)
            .animation(.easeInOut(duration: .durationShort), value: isEnabled)
    }
}

#if DEBUG
struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: .spacingSmall) {
                Button("Next", action: {}).primaryStyle(expansive: false)
                Button("Next", action: {}).primaryStyle()
                Button("Next", action: {}).primaryStyle().disabled(true)
            }

            VStack(spacing: .spacingSmall) {
                Button("Next", action: {}).secondaryStyle(expansive: false)
                Button("Next", action: {}).secondaryStyle()
                Button("Next", action: {}).secondaryStyle().disabled(true)
            }

            VStack(spacing: .spacingSmall) {
                Button("Next", action: {}).tertiaryStyle(expansive: false)
                Button("Next", action: {}).tertiaryStyle()
                Button("Next", action: {}).tertiaryStyle().disabled(true)
            }

            VStack(spacing: .spacingSmall) {
                Button("Next", action: {}).quaternaryStyle(expansive: false)
                Button("Next", action: {}).quaternaryStyle()
                Button("Next", action: {}).quaternaryStyle().disabled(true)
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
