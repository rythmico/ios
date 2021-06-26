extension View {
    public func watermark(_ uiImage: UIImage, offset: CGSize, opacity: Double? = nil) -> some View {
        modifier(
            WatermarkModifier(
                uiImage: uiImage,
                offsetX: offset.width,
                offsetY: offset.height,
                opacity: opacity ?? 0.08
            )
        )
    }
}

private struct WatermarkModifier: ViewModifier {
    var uiImage: UIImage
    @ScaledMetric(relativeTo: .largeTitle)
    var width: CGFloat = 200
    @ScaledMetric(relativeTo: .title3)
    var offsetX: CGFloat = 0
    @ScaledMetric(relativeTo: .largeTitle)
    var offsetY: CGFloat = 0
    var opacity: Double

    func body(content: Content) -> some View {
        content.background(
            Image(uiImage: uiImage.resized(width: width))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
                .fixedSize()
                .opacity(opacity)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: offsetX, y: offsetY)
        )
    }
}
