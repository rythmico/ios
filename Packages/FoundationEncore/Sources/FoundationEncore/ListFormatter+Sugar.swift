extension ListFormatter {
    public func string<C>(from strings: C) -> String where C: RandomAccessCollection, C.Element: StringProtocol {
        guard let string = string(from: strings.map { $0 as Any }) else {
            preconditionFailure("ListFormatter failed to list strings: '\(strings)'")
        }
        return string
    }
}
