extension Result {
    public init?(value: Success?, error: Failure?) {
        switch (value, error) {
        case (let value?, _):
            self = .success(value)
        case (_, let error?):
            self = .failure(error)
        case (nil, nil):
            return nil
        }
    }
}

extension Result where Success == Void {
    public static var success: Result { .success(()) }
}

extension Result {
    public func eraseError() -> Result<Success, Error> {
        mapError { $0 as Error }
    }
}

public protocol AnyResult {
    associatedtype Success
    associatedtype Failure

    func get() throws -> Success
}

extension AnyResult {
    public var successValue: Success? {
        try? get()
    }

    public var failureValue: Failure? {
        do {
            _ = try get()
        } catch {
            return error as? Failure
        }
        return nil
    }

    public var isSuccess: Bool {
        successValue != nil
    }

    public var isFailure: Bool {
        failureValue != nil
    }
}

extension Result: AnyResult {}
