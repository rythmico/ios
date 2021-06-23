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

extension NumberFormatter {
    public func string(from decimal: Decimal) -> String {
        guard let string = string(from: decimal as NSDecimalNumber) else {
            preconditionFailure("Failed to format Decimal '\(decimal)'")
        }
        return string
    }
}
