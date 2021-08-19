extension View {
    public func backgroundColor(_ color: Color) -> some View {
        self.background(InteractiveBackground(color: color).edgesIgnoringSafeArea(.all).animation(.none))
    }
}
