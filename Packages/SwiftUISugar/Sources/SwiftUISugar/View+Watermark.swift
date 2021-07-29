extension View {
    public func watermark(_ uiImage: UIImage, offset: CGSize, color: Color? = nil) -> some View {
        modifier(
            WatermarkModifier(
                uiImage: uiImage,
                offsetX: offset.width,
                offsetY: offset.height,
                color: color
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
    @Environment(\.colorScheme)
    var colorScheme
    let color: Color?

    func body(content: Content) -> some View {
        content.background(
            Image(uiImage: uiImage.resized(width: width))
                .renderingMode(color != nil ? .template : .original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
                .fixedSize()
                .foregroundColor(color)
                .opacity(colorScheme == .dark ? 0.17 : 0.05)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: offsetX, y: offsetY)
        )
    }
}
