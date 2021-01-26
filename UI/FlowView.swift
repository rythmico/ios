import SwiftUI

struct FlowView<FlowType: Flow, Content: View>: View {
    typealias Step = FlowType.Step

    @StateObject
    var flow: FlowType
    var content: (Step) -> Content

    init(flow: FlowType, @ViewBuilder content: @escaping (Step) -> Content) {
        self._flow = .init(wrappedValue: flow)
        self.content = content
    }

    var body: some View {
        ZStack {
            ForEach(0..<Step.count) { index in
                if index == flow.currentStep.index {
                    content(flow.currentStep).transition(transition(forStepIndex: index))
                } else {
                    EmptyView().transition(transition(forStepIndex: index))
                }
            }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: flow.currentStep.index)
    }

    private func transition(forStepIndex index: Int) -> AnyTransition {
        AnyTransition.move(
            edge: index == flow.currentStep.index
                ? flow.direction == .forward ? .trailing : .leading
                : flow.direction == .forward ? .leading : .trailing
        )
        .combined(with: .opacity)
    }
}

private enum Direction {
    case forward, backward

    init?<T: Comparable>(from: T, to: T) {
        switch true {
        case from < to: self = .forward
        case from > to: self = .backward
        default: return nil
        }
    }
}

private extension Flow {
    var direction: Direction? {
        previousStep.flatMap { Direction(from: $0, to: currentStep) }
    }
}
