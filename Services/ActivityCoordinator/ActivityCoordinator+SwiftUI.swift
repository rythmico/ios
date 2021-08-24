import SwiftUIEncore

extension View {
    func onReady<Input, Output>(
        _ coordinator: ActivityCoordinator<Input, Output>,
        perform action: @escaping () -> Void
    ) -> some View {
        onCoordinatorState(coordinator, { $0.isReady ? () : nil }, perform: action)
    }

    func onLoading<Input, Output>(
        _ coordinator: ActivityCoordinator<Input, Output>,
        perform action: @escaping () -> Void
    ) -> some View {
        onCoordinatorState(coordinator, { $0.isLoading ? () : nil }, perform: action)
    }

    func onSuspended<Input, Output>(
        _ coordinator: ActivityCoordinator<Input, Output>,
        perform action: @escaping () -> Void
    ) -> some View {
        onCoordinatorState(coordinator, { $0.isSuspended ? () : nil }, perform: action)
    }

    func onFinished<Input, Output>(
        _ coordinator: ActivityCoordinator<Input, Output>,
        perform action: @escaping (Output) -> Void
    ) -> some View {
        onCoordinatorState(coordinator, \.finishedValue, perform: action)
    }

    func onSuccess<Input, Success>(
        _ coordinator: FailableActivityCoordinator<Input, Success>,
        perform action: @escaping (Success) -> Void
    ) -> some View {
        onCoordinatorState(coordinator, \.successValue, perform: action)
    }

    func onFailure<Input, Success>(
        _ coordinator: FailableActivityCoordinator<Input, Success>,
        perform action: @escaping (Error) -> Void
    ) -> some View {
        onCoordinatorState(coordinator, \.failureValue, perform: action)
    }

    func onIdle<Input, Output>(
        _ coordinator: ActivityCoordinator<Input, Output>,
        perform action: @escaping () -> Void
    ) -> some View {
        onCoordinatorState(coordinator, { $0.isIdle ? () : nil }, perform: action)
    }

    private func onCoordinatorState<Input, Output, Value>(
        _ coordinator: ActivityCoordinator<Input, Output>,
        _ stateMap: @escaping (ActivityCoordinator<Input, Output>.State) -> Value?,
        perform action: @escaping (Value) -> Void
    ) -> some View {
        onReceive(
            coordinator.$state,
            perform: { stateMap($0).map(action) }
        )
    }
}

extension View {
    func alertOnFailure<Input, Success>(
        _ coordinator: FailableActivityCoordinator<Input, Success>,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        multiModal {
            $0.alert(
                error: coordinator.state.failureValue,
                dismiss: {
                    coordinator.dismissFailure()
                    onDismiss?()
                }
            )
        }
    }
}
