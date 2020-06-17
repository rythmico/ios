import SwiftUI

struct CloseButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemSymbol: .xmark).font(.system(size: 21, weight: .semibold))
                    .padding(.horizontal, .spacingExtraLarge)
                    .offset(x: .spacingExtraLarge)
            }
        }
        .foregroundColor(.accentColor)
        .accessibility(label: Text("Close"))
    }
}
