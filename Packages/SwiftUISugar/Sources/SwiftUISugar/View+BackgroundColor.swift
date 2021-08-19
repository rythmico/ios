extension View {
    public func backgroundColor(_ color: Color) -> some View {
        self.background(color.edgesIgnoringSafeArea(.all).animation(.none))
    }
}
