import Foundation

extension Optional {
    public mutating func nilifiedIfSome() -> Bool {
        switch self {
        case .some:
            self = nil
            return true
        case .none:
            return false
        }
    }
}
