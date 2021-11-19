extension LessonPlanRequest.PartialAddress {
    public enum FormatStyle {
        case singleLine
        case multiline
    }

    public func formatted(style: FormatStyle) -> String {
        switch style {
        case .singleLine:
            return [
                district.nilIfBlank,
                districtCode.nilIfBlank,
            ]
            .lazy
            .compacted()
            .joined(separator: .comma + .whitespace)
        case .multiline:
            return [
                district.nilIfBlank,
                districtCode.nilIfBlank,
            ]
            .lazy
            .compacted()
            .joined(separator: .newline)
        }
    }
}
