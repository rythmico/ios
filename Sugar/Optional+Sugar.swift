import Foundation

extension Optional {
    public mutating func nilifyIfSome() -> Bool {
        switch self {
        case .some:
            self = nil
            return true
        case .none:
            return false
        }
    }
}

extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        self?.isEmpty != false
    }
}
