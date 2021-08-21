extension View {
    @ViewBuilder
    public func `if`<Transform: View>(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
