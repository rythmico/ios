public struct AdHocButtonStyle<Body: View>: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    public typealias MakeBody = (_ configuration: Configuration, _ isEnabled: Bool) -> Body

    @ViewBuilder
    public let makeBody: MakeBody

    public init(makeBody: @escaping MakeBody) {
        self.makeBody = makeBody
    }

    public func makeBody(configuration: Configuration) -> Body {
        makeBody(configuration, isEnabled)
    }
}
