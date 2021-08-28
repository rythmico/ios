public struct PagingIndicator<Items: RandomAccessCollection>: View where Items.Element: Hashable {
    public typealias Item = Items.Element

    @Binding
    var selection: Item
    let items: Items
    let foregroundColor: Color
    let accentColor: Color

    public init(
        selection: Binding<Item>,
        items: Items,
        foregroundColor: Color = .white.opacity(0.5),
        accentColor: Color = .white
    ) {
        self._selection = selection
        self.items = items
        self.foregroundColor = foregroundColor
        self.accentColor = accentColor
    }

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.self) { item in
                PagingIndicatorDot(color: selection == item ? accentColor : foregroundColor)
            }
        }
    }
}

private struct PagingIndicatorDot: View {
    var color: Color

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
    }
}

#if DEBUG
struct PageDotIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PagingIndicator(selection: .constant(1), items: [1, 2, 3])
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.black)
    }
}
#endif
