import SwiftUI

struct RoundedShadowContainer: ViewModifier {
    private enum Const {
        static let cornerRadius: CGFloat = 10
        static let cornerStyle: RoundedCornerStyle = .continuous
    }

    @Environment(\.isEnabled) var isEnabled
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(background)
            .opacity(isEnabled ? 1 : 0.7)
    }

    private var background: some View {
        let shape = RoundedRectangle(cornerRadius: Const.cornerRadius, style: Const.cornerStyle)
        switch isEnabled {
        case true:
            let base = shape.fill(Color.rythmicoBackground)
            return colorScheme == .light
                ? AnyView(base.shadow(color: Color(white: 0, opacity: 0.14), radius: 5, x: 0, y: 2))
                : AnyView(base.overlay(shape.stroke(Color.rythmicoGray20, lineWidth: 1)))
        case false:
            return AnyView(shape.fill(Color.rythmicoGray5))
        }
    }
}
