extension View {
    public func padding(_ horizontal: HorizontalInsets, _ vertical: VerticalInsets) -> some View {
        self.padding(EdgeInsets(horizontal: horizontal, vertical: vertical))
    }

    public func padding(_ horizontal: HorizontalInsets) -> some View {
        self.padding(EdgeInsets(horizontal: horizontal))
    }

    public func padding(_ vertical: VerticalInsets) -> some View {
        self.padding(EdgeInsets(vertical: vertical))
    }
}
