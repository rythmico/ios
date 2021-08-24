extension View {
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
