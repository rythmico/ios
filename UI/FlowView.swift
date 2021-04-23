import SwiftUI

typealias _Flow = Flow

struct FlowView<Flow: _Flow, Content: View>: View {
    typealias Step = Flow.Step

    @ObservedObject
    var flow: Flow
    var transition: FlowTransition
    var animation: Animation
    var content: (Step) -> Content

    init(
        flow: Flow,
        transition: FlowTransition = .slide,
        animation: Animation = .rythmicoSpring(duration: .durationMedium),
        @ViewBuilder content: @escaping (Step) -> Content
    ) {
        self.flow = flow
        self.transition = transition
        self.animation = animation
        self.content = content
    }

    var body: some View {
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
