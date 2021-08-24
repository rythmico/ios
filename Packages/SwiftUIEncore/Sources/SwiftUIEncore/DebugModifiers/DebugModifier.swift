extension View {
    public func debugModifier<T: View>(@ViewBuilder _ modifier: (Self) -> T) -> some View {
        #if DEBUG
        return modifier(self)
        #else
        return self
        #endif
    }
}
