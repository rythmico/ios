public struct TransientContentView<FromContent: View, ToContent: View>: View {
    let delay: Double?
    let from: FromContent
    let to: ToContent

    public init(
        delay: Double? = nil,
        @ViewBuilder from: () -> FromContent,
        @ViewBuilder to: () -> ToContent
    ) {
        self.delay = delay
        self.from = from()
        self.to = to()
    }

    public var body: some View {
        TransientStateView(delay: delay, from: true, to: false) { flag in
            if flag {
                from
            } else {
                to
            }
        }
    }
}
