import SwiftUI

struct RoundedThinOutlineContainer: ViewModifier {
    var padded: Bool

    func body(content: Content) -> some View {
        content
            .padding(.vertical, padded ? 14 : 0)
            .padding(.horizontal, padded ? .spacingSmall : 0)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .strokeBorder(Color.rythmicoGray90, lineWidth: 1)
            )
    }
}
