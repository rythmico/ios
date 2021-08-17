import SwiftUISugar

struct LoadableCollectionView<Content: View>: View {
    let isLoading: Bool
    let topPadding: Bool
    @ViewBuilder
    let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                ActivityIndicator(color: .rythmico.foreground)
                    .padding(.top, spinnerTopPadding)
                    .padding(.bottom, .grid(5))
                    .transition(.scale(scale: 1, anchor: .top))
            }
            CollectionView(topPadding: isLoading ? 0 : contentTopPadding, content: content)
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: isLoading)
    }

    private var spinnerTopPadding: CGFloat {
        topPadding ? .grid(5) : 0
    }

    private var contentTopPadding: CGFloat {
        topPadding ? .grid(4) : 0
    }
}
