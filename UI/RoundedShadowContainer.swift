import SwiftUI

struct RoundedShadowContainer: ViewModifier {
    private enum Const {
        static let cornerRadius: CGFloat = 10
        static let cornerStyle: RoundedCornerStyle = .continuous
    }

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .background(background)
            .opacity(isEnabled ? 1 : 0.75)
    }

    @ViewBuilder
    private var background: some View {
        let shape = RoundedRectangle(cornerRadius: Const.cornerRadius, style: Const.cornerStyle)
        if isEnabled {
            let base = shape.fill(Color.rythmico.backgroundTertiary)
            switch colorScheme {
            case .dark:
                base.overlay(shape.stroke(Color.rythmico.gray20, lineWidth: 1))
            case .light:
                base.shadow(color: Color(white: 0, opacity: 0.14), radius: 5, x: 0, y: 2)
            @unknown default:
                base.shadow(color: Color(white: 0, opacity: 0.14), radius: 5, x: 0, y: 2)
            }
        } else {
            shape.fill(disabledBackgroundColor)
        }
    }

    private var disabledBackgroundColor: Color {
        Color(light: 0xF4F4F4, dark: 0x242424)
    }
}
