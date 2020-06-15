import SwiftUI

struct BackButton: View {
    var title = "Back"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemSymbol: .chevronLeft).font(.system(size: 21, weight: .semibold))
                Text(title).rythmicoFont(.bodyMedium)
            }
            .padding([.vertical, .trailing], .spacingSmall)
        }
        .foregroundColor(.accentColor)
    }
}
