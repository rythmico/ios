import SwiftUI

struct RoundedGrayedDialog: ViewModifier {
    private enum Const {
        static let cornerRadius: CGFloat = 10
        static let cornerStyle: RoundedCornerStyle = .continuous
    }

    func body(content: Content) -> some View {
        content.background(background)
    }

    @ViewBuilder
    private var background: some View {
        let shape = RoundedRectangle(cornerRadius: Const.cornerRadius, style: Const.cornerStyle)
        shape.fill(Color.rythmicoGray5).overlay(shape.stroke(Color.rythmicoGray20, lineWidth: 1))
    }
}