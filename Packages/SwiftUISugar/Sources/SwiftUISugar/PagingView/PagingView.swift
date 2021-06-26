public struct PagingView<Data: RandomAccessCollection, Selection: Hashable, Content: View>: View where Data.Element == Selection {
    private let data: Data
    @Binding
    private var selection: Selection
    private let fixedHeight: CGFloat?
    private let spacing: CGFloat
    private let accentColor: Color
    private let content: (Data.Element) -> Content

    public init(
        data: Data,
        selection: Binding<Selection>,
        fixedHeight: CGFloat? = nil,
        spacing: CGFloat,
        accentColor: Color,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self._selection = selection
        self.fixedHeight = fixedHeight
        self.spacing = spacing
        self.accentColor = accentColor
        self.content = content
    }

    public var body: some View {
        VStack(spacing: spacing) {
            TabView(selection: $selection) {
                ForEach(data, id: \.self) { content($0).tag($0) }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(idealHeight: fixedHeight)
            .fixedSize(horizontal: false, vertical: fixedHeight != nil)

            PagingIndicator(
                selection: $selection,
                items: data,
                foregroundColor: accentColor.opacity(0.25),
                accentColor: accentColor
            )
        }
    }
}
