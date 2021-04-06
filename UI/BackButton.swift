import SwiftUI

struct BackButton: View {
    var title = "Back"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: .spacingUnit) {
                Image(systemSymbol: .chevronLeft).font(.system(size: 21, weight: .medium))
                Text(title).rythmicoFont(.bodyMedium).offset(y: -1)
            }
            .padding([.vertical, .trailing], .spacingSmall)
        }
        .foregroundColor(.accentColor)
    }
}

#if DEBUG
struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(action: {})
            .previewLayout(.sizeThatFits)
    }
}
#endif
