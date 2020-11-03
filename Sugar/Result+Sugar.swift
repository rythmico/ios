import Foundation

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
