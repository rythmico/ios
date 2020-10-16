import SwiftUI

struct CoordinatorStateView<Input, Success, InputContent: View, LoadingContent: View, SuccessContent: View>: View {
    typealias Coordinator = FailableActivityCoordinator<Input, Success>

    @ObservedObject
    private var coordinator: Coordinator
    private var successContent: SuccessContent
    private var loadingContent: LoadingContent
    private var inputContent: InputContent

    init(
        coordinator: Coordinator,
        @ViewBuilder successContent: () -> SuccessContent,
        @ViewBuilder loadingContent: () -> LoadingContent,
        @ViewBuilder inputContent: () -> InputContent
    ) {
        self.coordinator = coordinator
        self.successContent = successContent()
        self.loadingContent = loadingContent()
        self.inputContent = inputContent()
    }

    var body: some View {
        ZStack {
            switch coordinator.state {
            case .finished(.success):
                successContent.transition(stateTransition(scale: 0.7))
            case .loading:
                loadingContent.transition(stateTransition(scale: 0.7))
            default:
                inputContent.transition(stateTransition(scale: 0.9))
            }
        }
    }

    private func stateTransition(scale: CGFloat) -> AnyTransition {
        AnyTransition
            .opacity
            .combined(with: .scale(scale: scale))
            .animation(.rythmicoSpring(duration: .durationShort))
    }
}
