extension View {
    /// - Important: This modifier is only meant to be used with non-`@State` values within a `View`.
    @ViewBuilder
    public func ifLet<V, Transform: View>(
        _ value: V?,
        @ViewBuilder transform: (Self, V) -> Transform
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}
