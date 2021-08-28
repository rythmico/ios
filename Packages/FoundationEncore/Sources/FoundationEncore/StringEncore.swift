extension String {
    public static var empty: String { "" }
    public static var whitespace: String { " " }
    public static var dash: String { "-" }
    public static var newline: String { "\n" }
    public static var period: String { "." }
    public static var comma: String { "," }
    public static var quote: String { "\"" }
    public static var openQuote: String { "“" }
    public static var closeQuote: String { "”" }
    public static var colon: String { ":" }
    public static var openParenthesis: String { "(" }
    public static var closeParenthesis: String { ")" }
}

extension StringProtocol {
    public var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var nilIfBlank: Self? {
        isBlank ? nil : self
    }

    public func quoted() -> String {
        .quote + String(self) + .quote
    }

    public func smartQuoted() -> String {
        .openQuote + String(self) + .closeQuote
    }

    public func parenthesized() -> String {
        .openParenthesis + String(self) + .closeParenthesis
    }

    public func repeated(_ count: Int = 2) -> String {
        String(repeating: String(self), count: count)
    }

    public func removingRepetition(of character: Character) -> String {
        self.reduce(.empty) { acc, current in
            if acc.last == character, current == character {
                return acc
            } else {
                return acc + current
            }
        }
    }

    public func trimmingLineCharacters(in set: CharacterSet) -> String {
        self.split(separator: .newline)
            .map { $0.trimmingCharacters(in: set) }
            .joined(separator: .newline)
    }
}

extension StringProtocol {
    public var words: [String] {
        self.components(separatedBy: .whitespacesAndNewlines)
            .filter(\.isBlank.not)
    }

    public func word(at index: Int) -> String? {
        self.components(separatedBy: .whitespacesAndNewlines)
            .lazy
            .filter(\.isBlank.not)[safe: index]
    }

    public var firstWord: String? {
        word(at: 0)
    }

    public func initials(_ count: Int = .max) -> String {
        self.split(separator: .whitespace)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .compactMap { $0.first?.uppercased() }
            .prefix(count)
            .joined()
    }
}

extension Collection where Element: StringProtocol {
    public func spaced() -> String {
        joined(separator: .whitespace)
    }

    public func spacedAndDashed() -> String {
        joined(separator: .whitespace + .dash + .whitespace)
    }
}
