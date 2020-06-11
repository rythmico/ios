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
                    .rythmicoFont(.bodyMedium, sizeCategory: sizeCategory, legibilityWeight: legibilityWeight)
                )
            }
        }
        .foregroundColor(.rythmicoGray90)
    }
}
