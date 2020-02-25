import SwiftUI

struct RoundedThinOutlineContainer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 14)
            .padding(.horizontal, .spacingSmall)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.rythmicoGray90, lineWidth: 1)
            )
    }
}
