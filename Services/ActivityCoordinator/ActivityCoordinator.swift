import Combine

class ActivityCoordinator<Output>: ObservableObject {
    enum State {
        case ready
        case loading
        case finished(Output)
        case idle
    }

    @Published
    /*protected(set)*/ var state: State = .ready

    func cancel() {
        if case .loading = state {
            state = .ready
        }
    }

    func reset() {
        cancel()
        state = .ready
    }

    deinit {
        cancel()
    }
}

class FailableActivityCoordinator<Success>: ActivityCoordinator<Result<Success, Error>> {
    func idle() {
        if case .finished(let result) = state, case .success = result {
            state = .idle
        }
    }

    func dismissFailure() {
        if case .finished(let result) = state, case .failure = result {
            state = .ready
        }
    }
}
