public struct CustomButton<Content: View>: View {
    public typealias Action = () -> Void
    public typealias MakeContent = (_ state: CustomButtonState) -> Content

    private let action: Action
    private let content: MakeContent

    public init(action: @escaping Action, @ViewBuilder content: @escaping MakeContent) {
        self.action = action
        self.content = content
    }

    public var body: some View {
        Button(action: action, label: EmptyView.init).buttonStyle(CustomButtonStyle { _, state in content(state) })
    }
}

public struct CustomButtonStyle<Body: View>: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    public typealias MakeBody = (_ label: ButtonStyleConfiguration.Label, _ state: CustomButtonState) -> Body

    private let makeBody: MakeBody

    public init(@ViewBuilder makeBody: @escaping MakeBody) {
        self.makeBody = makeBody
    }

    public func makeBody(configuration: Configuration) -> some View {
        makeBody(
            configuration.label,
            CustomButtonState(isPressed: configuration.isPressed, isEnabled: isEnabled)
        )
        .contentShape(Rectangle())
    }
}
