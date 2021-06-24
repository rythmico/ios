import SwiftUI

struct BackButton: View {
    static let uiImage = UIImage(systemSymbol: .chevronLeft).applyingSymbolConfiguration(.init(pointSize: 17, weight: .medium, scale: .large))!
    static let image: some View = Image(systemSymbol: .chevronLeft).font(.system(size: 17, weight: .medium)).imageScale(.large)

    var title = "Back"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: .grid(1)) {
                Self.image
                Text(title).rythmicoTextStyle(.bodyMedium)
            }
            .padding([.vertical, .trailing], .grid(4))
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
