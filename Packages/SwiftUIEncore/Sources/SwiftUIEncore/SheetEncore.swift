extension View {
    public func sheet<Item, Content: View>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        sheet(isPresented: item.isPresent(), onDismiss: onDismiss) {
            item.wrappedValue.map(content)
        }
    }

    public func fullScreenCover<Item, Content: View>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        fullScreenCover(isPresented: item.isPresent(), onDismiss: onDismiss) {
            item.wrappedValue.map(content)
        }
    }
}
