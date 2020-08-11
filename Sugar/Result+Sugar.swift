import Foundation

public protocol AnyResult {
    associatedtype Success
    associatedtype Failure

    func get() throws -> Success
}

extension Result: AnyResult {}

extension Result {
    public var successValue: Success? {
        guard case .success(let value) = self else {
            return nil
        }
        return value
    }

    public var failureValue: Failure? {
        guard case .failure(let error) = self else {
            return nil
        }
        return error
    }
}
