import Foundation

public protocol AnyResult {
    associatedtype Success
    associatedtype Failure

    func get() throws -> Success
}

extension Result: AnyResult {}
