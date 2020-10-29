import Foundation

extension Sequence {
    @inlinable
    public func count(
        where predicate: (Element) throws -> Bool
    ) rethrows -> Int {
        var count = 0
        for e in self {
            if try predicate(e) {
                count += 1
            }
        }
        return count
    }

    public func compact<T>() -> [T] where Element == Optional<T> {
        compactMap { $0 }
    }
}
