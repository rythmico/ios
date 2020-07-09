import Combine

class ActivityCoordinator<Output>: ObservableObject {
    enum State {
        case idle
        case loading
        case finished(Output)
    }

    @Published
    /*private(set)*/ var state: State = .idle
}

class FailableActivityCoordinator<Success>: ActivityCoordinator<Result<Success, Error>> {
    func dismissFailure() {
        if case .finished(let result) = state, case .failure = result {
            state = .idle
        }
    }
}
