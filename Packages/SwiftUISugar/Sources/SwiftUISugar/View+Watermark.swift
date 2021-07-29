extension View {
    public func watermark(_ uiImage: UIImage, offset: CGSize, color: Color? = nil, opacity: Double? = nil) -> some View {
        modifier(
            WatermarkModifier(
                uiImage: uiImage,
                offsetX: offset.width,
                offsetY: offset.height,
                color: color,
                opacity: opacity ?? 0.08
            )
        )
    }
}

private struct WatermarkModifier: ViewModifier {
    let uiImage: UIImage
    @ScaledMetric(relativeTo: .largeTitle)
    var width: CGFloat = 200
    @ScaledMetric(relativeTo: .title3)
    var offsetX: CGFloat = 0
    @ScaledMetric(relativeTo: .largeTitle)
    var offsetY: CGFloat = 0
    let color: Color?
    let opacity: Double

    func body(content: Content) -> some View {
        content.background(
            Image(uiImage: uiImage.resized(width: width))
                .renderingMode(color != nil ? .template : .original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
                .fixedSize()
                .foregroundColor(color)
                .opacity(opacity)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: offsetX, y: offsetY)
        )
    }
}
