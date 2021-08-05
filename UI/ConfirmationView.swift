import SwiftUI

struct ConfirmationView: View {
    var title: String

    var body: some View {
        ZStack {
            Color.clear
            HStack(spacing: .grid(3)) {
                Image.checkmarkIcon(color: .rythmico.picoteeBlue)
                Text(title)
                    .rythmicoTextStyle(.subheadlineBold)
                    .foregroundColor(.rythmico.foreground)
            }
        }
    }
}

#if DEBUG
struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(title: "Plan cancelled successfully")
            .previewLayout(.sizeThatFits)
    }
}
#endif
