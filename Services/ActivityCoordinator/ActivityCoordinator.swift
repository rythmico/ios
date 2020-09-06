import Combine

class ActivityCoordinator<Output>: ObservableObject {
    enum State {
        case idle
        case loading
        case finished(Output)
    }

    @Published
    /*protected(set)*/ var state: State = .idle

    func cancel() {
        if case .loading = state {
            state = .idle
        }
    }

    func reset() {
        cancel()
        state = .idle
    }

    deinit {
        cancel()
    }
}

class FailableActivityCoordinator<Success>: ActivityCoordinator<Result<Success, Error>> {
    func dismissFailure() {
        if case .finished(let result) = state, case .failure = result {
            state = .idle
        }
    }
}
