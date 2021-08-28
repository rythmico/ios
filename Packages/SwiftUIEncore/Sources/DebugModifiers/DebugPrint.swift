extension View {
    public func debugPrint(_ value: Any) -> Self {
        debugAction { print(value) }
    }
}
