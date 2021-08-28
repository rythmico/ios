extension View {
    public func alert<Item>(item: Binding<Item?>, content: (Item) -> Alert) -> some View {
        alert(
            isPresented: Binding(
                get: { item.wrappedValue != nil },
                set: { if !$0 { item.wrappedValue = nil } }
            ),
            content: { content(item.wrappedValue!) }
        )
    }

    public func alert(item: Binding<Alert?>) -> some View {
        alert(item: item, content: { $0 })
    }
}
