import SwiftUI

struct LoadingView: View {
    var title: String

    var body: some View {
        ZStack {
            Color.clear
            HStack(spacing: .spacingExtraSmall) {
                ActivityIndicator(color: .rythmicoGray90)
                Text(title)
                    .rythmicoTextStyle(.subheadlineBold)
                    .foregroundColor(.rythmicoForeground)
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
