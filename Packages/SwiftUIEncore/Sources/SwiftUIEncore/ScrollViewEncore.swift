extension ScrollView {
    public init<InnerContent: View>(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: @escaping (ScrollViewProxy) -> InnerContent
    ) where Content == ScrollViewReader<InnerContent> {
        self.init(axes, showsIndicators: showsIndicators) {
            ScrollViewReader(content: content)
        }
    }
}
