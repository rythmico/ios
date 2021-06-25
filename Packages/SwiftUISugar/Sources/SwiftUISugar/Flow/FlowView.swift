public typealias _Flow = Flow

public struct FlowView<Flow: _Flow, Content: View>: View {
    public typealias Step = Flow.Step

    @ObservedObject
    private var flow: Flow
    private var transition: FlowTransition
    private var animation: Animation
    private var content: (Step) -> Content

    public init(
        flow: Flow,
        transition: FlowTransition = .slide,
        animation: Animation,
        @ViewBuilder content: @escaping (Step) -> Content
    ) {
        self.flow = flow
        self.transition = transition
        self.animation = animation
        self.content = content
    }

    public var body: some View {
        ZStack {
            ForEach(0..<Step.count) { index in
                if index == currentStep.index {
                    content(currentStep).transition(transitionForCurrentDirection())
                } else {
                    EmptyView().transition(transitionForCurrentDirection())
                }
            }
        }
        .onReceive(flow.objectWillChange.map { [old = flow.step] _ in old }, perform: onFlowChanged)
        .animation(animation, value: currentStep.index)
    }

    @State
    private var previousStep: Step?
    private var currentStep: Step { flow.step }
    private var direction: FlowDirection? {
        previousStep.flatMap { FlowDirection(from: $0, to: flow.step) }
    }

    private func transitionForCurrentDirection() -> AnyTransition {
        direction.map(transition.map) ?? transition.map(.forward)
    }

    private func onFlowChanged(previousStep: Step) {
        guard self.previousStep?.index != previousStep.index else { return }
        self.previousStep = previousStep
    }
}
