import SwiftUI

struct CoordinatorStateView<Input, Success, InputContent: View, LoadingContent: View, SuccessContent: View>: View {
    typealias Coordinator = FailableActivityCoordinator<Input, Success>

    @ObservedObject
    private var coordinator: Coordinator
    private var successContent: (Success) -> SuccessContent
    private var loadingContent: LoadingContent
    private var inputContent: InputContent

    init(
        coordinator: Coordinator,
        @ViewBuilder successContent: @escaping (Success) -> SuccessContent,
        @ViewBuilder loadingContent: () -> LoadingContent,
        @ViewBuilder inputContent: () -> InputContent
    ) {
        self.coordinator = coordinator
        self.successContent = successContent
        self.loadingContent = loadingContent()
        self.inputContent = inputContent()
    }

    var body: some View {
        ZStack {
            switch coordinator.state {
            case .finished(.success(let successValue)):
                successContent(successValue).transition(stateTransition(scale: 0.7))
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

extension CoordinatorStateView where LoadingContent == LoadingView {
    init(
        coordinator: Coordinator,
        @ViewBuilder successContent: @escaping (Success) -> SuccessContent,
        loadingTitle: String,
        @ViewBuilder inputContent: () -> InputContent
    ) {
        self.init(
            coordinator: coordinator,
            successContent: successContent,
            loadingContent: { LoadingView(title: loadingTitle) },
            inputContent: inputContent
        )
    }
}

extension CoordinatorStateView where SuccessContent == ConfirmationView {
    init(
        coordinator: Coordinator,
        successTitle: String,
        @ViewBuilder loadingContent: () -> LoadingContent,
        @ViewBuilder inputContent: () -> InputContent
    ) {
        self.init(
            coordinator: coordinator,
            successContent: { _ in ConfirmationView(title: successTitle) },
            loadingContent: loadingContent,
            inputContent: inputContent
        )
    }
}

extension CoordinatorStateView where LoadingContent == LoadingView, SuccessContent == ConfirmationView {
    init(
        coordinator: Coordinator,
        successTitle: String,
        loadingTitle: String,
        @ViewBuilder inputContent: () -> InputContent
    ) {
        self.init(
            coordinator: coordinator,
            successContent: { _ in ConfirmationView(title: successTitle) },
            loadingContent: { LoadingView(title: loadingTitle) },
            inputContent: inputContent
        )
    }
}
