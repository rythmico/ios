import Foundation
import Then

extension Then where Self: Any {
    func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        with { $0[keyPath: keyPath] = value }
    }
}

extension Then where Self: AnyObject {
    func with<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, _ value: T) -> Self {
        then { $0[keyPath: keyPath] = value }
    }
}

extension JSONDecoder: Then {}
extension URLRequest: Then {}
