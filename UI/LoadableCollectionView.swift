import SwiftUISugar

struct LoadableCollectionView<Content: View>: View {
    let isLoading: Bool
    let topPadding: Bool
    @ViewBuilder
    let content: Content

    var body: some View {
        ZStack(alignment: .top) {
            CollectionView(topPadding: contentTopPadding) {
                content
            }
            spinnerView
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: isLoading)
    }

    @ViewBuilder
    private var spinnerView: some View {
        if isLoading {
            ActivityIndicator(color: .rythmico.foreground)
                .background(
                    Color.rythmico.background.clipShape(Circle().inset(by: .grid(-3))).blur(radius: 5)
                )
                .padding(.top, spinnerTopPadding)
                .padding(.bottom, .grid(5))
        }
    }

    private var spinnerTopPadding: CGFloat {
        topPadding ? .grid(5) : 0
    }

    private var contentTopPadding: CGFloat {
        (topPadding ? .grid(4) : 0) + (isLoading ? 42 : 0)
    }
}

#if DEBUG
struct LoadableCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        LoadableCollectionView(isLoading: true, topPadding: true) {
            ForEach(0..<30, id: \.self) { _ in Color.red.frame(height: 40) }
        }
    }
}
#endif
