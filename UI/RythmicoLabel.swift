import SwiftUISugar

struct RythmicoLabel<Icon: View, Title: View>: View {
    @ViewBuilder
    let icon: Icon
    @ViewBuilder
    let title: Title

    var body: some View {
        HStack(spacing: .grid(2)) {
            icon
            title.lineLimit(1).minimumScaleFactor(0.7)
        }
    }
}

extension RythmicoLabel where Icon == Image {
    init(asset: ImageAsset, @ViewBuilder title: () -> Title) {
        self.init(icon: { Image(decorative: asset.name).renderingMode(.template) }, title: title)
    }
}
