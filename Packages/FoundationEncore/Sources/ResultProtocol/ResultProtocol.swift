public protocol ResultProtocol {
    associatedtype Success
    associatedtype Failure

    func get() throws -> Success
}

extension ResultProtocol {
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

extension Result: ResultProtocol {}
