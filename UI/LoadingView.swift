import SwiftUI

struct LoadingView: View {
    var title: String

    var body: some View {
        ZStack {
            Color.clear
            HStack(spacing: .grid(3)) {
                ActivityIndicator(color: .rythmico.foreground)
                Text(title)
                    .rythmicoTextStyle(.subheadlineBold)
                    .foregroundColor(.rythmico.foreground)
            }
        }
    }
}

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(title: "Submitting proposal...")
            .previewLayout(.sizeThatFits)
    }
}
#endif
