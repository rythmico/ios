import SwiftUI

struct RoundedThickOutlineContainer: ViewModifier {
    var backgroundColor: Color = .clear
    var borderColor: Color = .rythmicoGray20

    func body(content: Content) -> some View {
        content
            .padding(.vertical, .spacingExtraSmall)
            .padding(.horizontal, .spacingSmall)
            .frame(minHeight: 56, maxHeight: .infinity)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(backgroundColor)
                    .opacity(0.1)
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: 2)
                }
            )
    }
}
