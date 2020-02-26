import SwiftUI

struct RoundedThickOutlineContainer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, .spacingExtraSmall)
            .padding(.horizontal, .spacingSmall)
            .frame(minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .strokeBorder(Color.rythmicoGray20, lineWidth: 2)
            )
    }
}
