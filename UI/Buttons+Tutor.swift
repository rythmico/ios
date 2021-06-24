import SwiftUI

extension Button {
    func primaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(
            RythmicoButtonStyle(
                expansive: expansive,
                foregroundColor: (normal: .white, pressed: .white),
                backgroundColor: (normal: .blue, pressed: .blue),
                borderColor: (normal: .clear, pressed: .clear),
                dimOnPress: true
            )
        )
    }

    func secondaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(
            RythmicoButtonStyle(
                expansive: expansive,
                foregroundColor: (normal: .blue, pressed: .white),
                backgroundColor: (normal: .clear, pressed: .blue),
                borderColor: (normal: .blue, pressed: .blue),
                dimOnPress: false
            )
        )
    }
}

private struct RythmicoButtonStyle: ButtonStyle {
    typealias StateColors = (normal: Color, pressed: Color)

    var expansive: Bool
    let buttonMaxWidth: CGFloat = .grid(85)
    var foregroundColor: StateColors
    var backgroundColor: StateColors
    var borderColor: StateColors
    var dimOnPress: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, .grid(5))
            .font(.body.bold())
            .foregroundColor(color(from: foregroundColor, for: configuration))
            .frame(maxWidth: expansive ? buttonMaxWidth : nil, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: .grid(2), style: .continuous)
                    .fill(color(from: backgroundColor, for: configuration))
                    .overlay(
                        RoundedRectangle(cornerRadius: .grid(2), style: .continuous)
                            .stroke(color(from: borderColor, for: configuration), lineWidth: 2)
                    )
                    .contentShape(Rectangle())
            )
            .modifier(DiseableableButtonModifier())
            .opacity(configuration.isPressed && dimOnPress ? 0.3 : 1)
    }

    func color(from colors: StateColors, for configuration: Configuration) -> Color {
        configuration.isPressed ? colors.pressed : colors.normal
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
            VStack(spacing: .grid(4)) {
                Button("Next", action: {}).primaryStyle(expansive: false)
                Button("Next", action: {}).primaryStyle()
                Button("Next", action: {}).primaryStyle().disabled(true)
            }

            VStack(spacing: .grid(4)) {
                Button("Next", action: {}).secondaryStyle(expansive: false)
                Button("Next", action: {}).secondaryStyle()
                Button("Next", action: {}).secondaryStyle().disabled(true)
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
