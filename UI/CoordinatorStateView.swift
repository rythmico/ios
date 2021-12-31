import SwiftUIEncore

struct CoordinatorStateView<Input, Success, InputContent: View, LoadingContent: View, SuccessContent: View>: View {
    typealias Coordinator = FailableActivityCoordinator<Input, Success>

    @ObservedObject
    var coordinator: Coordinator
    @ViewBuilder
    var successContent: (Success) -> SuccessContent
    @ViewBuilder
    var loadingContent: LoadingContent
    @ViewBuilder
    var inputContent: InputContent

    var body: some View {
        ZStack {
            switch coordinator.state {
            case .finished(.success(let successValue)):
                successContent(successValue).transition(stateTransition)
            case .loading:
                loadingContent.transition(stateTransition)
            default:
                inputContent.transition(stateTransition)
            }
        }
    }

    private var stateTransition: AnyTransition {
        (.scale(scale: 0.9) + .opacity).animation(.rythmicoSpring(duration: .durationShort))
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
