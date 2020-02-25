import SwiftUI

struct BackButton: View {
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.legibilityWeight) private var legibilityWeight

    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemSymbol: .chevronLeft).font(.system(size: 21, weight: .semibold))
                Text("Back").font(
                    .system(
                        size: Font.TextStyle.callout.fontSize(for: sizeCategory),
                        weight: legibilityWeight == .bold ? .bold : .medium,
                        design: .rounded
                    )
                )
            }
        }
        .foregroundColor(.rythmicoGray90)
    }
}
