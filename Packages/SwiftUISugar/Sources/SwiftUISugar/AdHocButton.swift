public struct AdHocButton<Content: View>: View {
    public typealias MakeBody = AdHocButtonStyleMakeBody<Content>

    private let action: Action
    private let makeBody: MakeBody

    public init(action: @escaping Action, @ViewBuilder makeBody: @escaping MakeBody) {
        self.action = action
        self.makeBody = makeBody
    }

    public var body: some View {
        Button(action: action, label: EmptyView.init).buttonStyle(AdHocButtonStyle(makeBody: makeBody))
    }
}

public struct AdHocButtonStyle<Body: View>: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    public typealias MakeBody = AdHocButtonStyleMakeBody<Body>

    private let makeBody: MakeBody

    public init(@ViewBuilder makeBody: @escaping MakeBody) {
        self.makeBody = makeBody
    }

    public func makeBody(configuration: Configuration) -> some View {
        makeBody(configuration, isEnabled).contentShape(Rectangle())
    }
}

public typealias AdHocButtonStyleMakeBody<Body> = (_ configuration: ButtonStyleConfiguration, _ isEnabled: Bool) -> Body
