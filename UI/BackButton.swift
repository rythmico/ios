import SwiftUI

struct BackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemSymbol: .chevronLeft).font(.system(size: 21, weight: .semibold))
                Text("Back").rythmicoFont(.bodyMedium)
            }
        }
        .foregroundColor(.rythmicoGray90)
    }
}
