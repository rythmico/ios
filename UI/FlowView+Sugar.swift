import SwiftUISugar

extension FlowView {
    init(
        flow: Flow,
        transition: FlowTransition = .slide,
        @ViewBuilder content: @escaping (Step) -> Content
    ) {
        self.init(
            flow: flow,
            transition: .slide,
            animation: .rythmicoSpring(duration: .durationMedium),
            content: content
        )
    }
}
