import Foundation

extension NumberFormatter {
    public enum Format {
        case price
    }

    public func setFormat(_ format: Format) {
        switch format {
        case .price:
            numberStyle = .currency
        }
    }
}
