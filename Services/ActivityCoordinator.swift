import Combine

class ActivityCoordinator<Output>: ObservableObject {
    enum State {
        case idle
        case loading
        case finished(Output)
    }

    @Published
    /*protected(set)*/ var state: State = .idle
}

class FailableActivityCoordinator<Success>: ActivityCoordinator<Result<Success, Error>> {
    func dismissFailure() {
        if case .finished(let result) = state, case .failure = result {
            state = .idle
        }
    }
}

import SwiftUI

extension View {
    func onIdle<Output>(
        _ coordinator: ActivityCoordinator<Output>,
        perform action: @escaping () -> Void
    ) -> some View {
        onCoordinatorState(coordinator, { $0.isIdle ? () : nil }, perform: action)
    }

    func onLoading<Output>(
        _ coordinator: ActivityCoordinator<Output>,
        perform action: @escaping () -> Void
    ) -> some View {
        onCoordinatorState(coordinator, { $0.isLoading ? () : nil }, perform: action)
    }

    func onFinished<Output>(
        _ coordinator: ActivityCoordinator<Output>,
        perform action: @escaping (Output) -> Void
    ) -> some View {
        onCoordinatorState(coordinator, \.finishedValue, perform: action)
    }

    func onSuccess<Success>(
        _ coordinator: FailableActivityCoordinator<Success>,
        perform action: @escaping (Success) -> Void
    ) -> some View {
        onCoordinatorState(coordinator, \.successValue, perform: action)
    }

    func onFailure<Success>(
        _ coordinator: FailableActivityCoordinator<Success>,
        perform action: @escaping (Error) -> Void
    ) -> some View {
        onCoordinatorState(coordinator, \.failureValue, perform: action)
    }

    private func onCoordinatorState<Value, Output>(
        _ coordinator: ActivityCoordinator<Value>,
        _ stateMap: @escaping (ActivityCoordinator<Value>.State) -> Output?,
        perform action: @escaping (Output) -> Void
    ) -> some View {
        onReceive(
            coordinator.$state,
            perform: { stateMap($0).map(action) }
        )
    }
}

extension View {
    func alertOnFailure<Success>(_ coordinator: FailableActivityCoordinator<Success>) -> some View {
        alert(error: coordinator.state.failureValue, dismiss: coordinator.dismissFailure)
    }
}
