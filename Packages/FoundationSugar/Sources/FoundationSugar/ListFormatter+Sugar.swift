extension ListFormatter {
    public func string(from strings: [String]) -> String {
        guard let string = string(from: strings.map { $0 as Any }) else {
            preconditionFailure("ListFormatter failed to list strings: '\(strings)'")
        }
        return string
    }
}
