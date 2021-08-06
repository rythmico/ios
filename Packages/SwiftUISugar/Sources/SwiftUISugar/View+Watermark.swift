extension View {
    public func watermark(_ uiImage: UIImage, color: Color? = nil, width: CGFloat? = nil, offset: CGSize) -> some View {
        modifier(
            WatermarkModifier(
                uiImage: uiImage,
                color: color,
                width: width ?? WatermarkModifier.defaultWidth,
                offsetX: offset.width,
                offsetY: offset.height
            )
        )
    }
}

private struct WatermarkModifier: ViewModifier {
    static let defaultWidth: CGFloat = 170

    let uiImage: UIImage
    let color: Color?
    @ScaledMetric(relativeTo: .largeTitle)
    var width: CGFloat = WatermarkModifier.defaultWidth
    @ScaledMetric(relativeTo: .title3)
    var offsetX: CGFloat = 0
    @ScaledMetric(relativeTo: .largeTitle)
    var offsetY: CGFloat = 0
    @Environment(\.colorScheme)
    var colorScheme

    func body(content: Content) -> some View {
        content.background(
            ZStack {
                Image(uiImage: uiImage.resized(width: width))
                    .renderingMode(color != nil ? .template : .original)
                    .frame(width: width)
                    .foregroundColor(color)
                    .opacity(colorScheme == .dark ? 0.125 : 0.05)
                    .offset(x: offsetX, y: offsetY)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        )
    }
}
