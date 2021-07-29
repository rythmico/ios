import SwiftUI

struct RoundedThickOutlineContainer: ViewModifier {
    var backgroundColor: Color = .clear
    var borderColor: Color = .rythmico.outline

    func body(content: Content) -> some View {
        content
            .padding(.vertical, .grid(4))
            .padding(.horizontal, .grid(4))
            .frame(minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(backgroundColor)
                    .opacity(0.07)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .strokeBorder(borderColor, lineWidth: 2)
                    )
            )
    }
}
