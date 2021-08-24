import SwiftUIEncore

struct DynamicImage: View {
    @Environment(\.sizeCategory) private var sizeCategory

    let asset: ImageAsset
    var renderingMode: Image.TemplateRenderingMode = .template

    var body: some View {
        Image(uiImage: asset.image.resized(width: iconWidth)).renderingMode(renderingMode)
    }

    private var iconWidth: CGFloat {
        UIFontMetrics(forTextStyle: .largeTitle)
            .scaledValue(
                for: asset.image.size.width,
                compatibleWith: .init(preferredContentSizeCategory: UIContentSizeCategory(sizeCategory))
            )
    }
}
