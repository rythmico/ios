// TODO: use iOS 15's custom FormatStyles
// https://emptytheory.com/2021/08/14/creating-custom-parseable-format-styles-in-ios-15/

public enum AddressFormatStyle {
    case multilineCompact
    case multiline
}

extension AddressProtocol {
    public func formatted(style: AddressFormatStyle) -> String {
        switch style {
        case .multilineCompact:
            return [
                [line1, line2],
                [line3, line4],
                [city, postcode]
            ]
            .lazy
            .compactMap { $0.compactMap(\.nilIfBlank).nilIfEmpty }
            .map { $0.joined(separator: .comma + .whitespace) }
            .joined(separator: .newline)
        case .multiline:
            return [
                line1,
                line2,
                line3,
                line4,
                city,
                postcode,
                country,
            ]
            .lazy
            .filter(\.isEmpty.not)
            .joined(separator: .newline)
        }
    }
}
