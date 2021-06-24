import SwiftUI

struct RoundedThinOutlineContainer: ViewModifier {
    var padded: Bool

    @Environment(\.isEnabled) private var isEnabled

    func body(content: Content) -> some View {
        content
            .padding(.vertical, padded ? 14 : 0)
            .padding(.horizontal, padded ? .grid(4) : 0)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .strokeBorder(Color.rythmicoGray90, lineWidth: 1)
            )
            .opacity(isEnabled ? 1 : 0.3)
    }
}
