import SwiftUI

struct BackButton: View {
    var title = "Back"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: .grid(1)) {
                Image.chevronLeft
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
