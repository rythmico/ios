import SwiftUI

struct MultiStyleText: View {
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.legibilityWeight) private var legibilityWeight

    var style: Font.TextStyle
    var parts: [Part]

    var body: some View {
        Group {
            if parts.isEmpty {
                EmptyView()
            } else {
                parts.reduce(Text("")) { text, part in
                    text + Text(part.string).font(
                        Font.system(
                            size: style.fontSize(for: sizeCategory),
                            weight: weight(for: part, systemLegibilityWeight: legibilityWeight),
                            design: .rounded
                        )
                    ).foregroundColor(part.color)
                }
                .lineSpacing(6)
            }
        }
    }

    private func weight(for part: Part, systemLegibilityWeight: LegibilityWeight?) -> Font.Weight {
        if systemLegibilityWeight == .bold {
            return part.weight == .bold ? .heavy : .bold
        }
        return style.weight(for: part.weight)
    }
}

extension MultiStyleText {
    struct Part: ExpressibleByStringLiteral {
        var string: String
        var weight: LegibilityWeight
        var color: Color

        init(_ string: String, weight: LegibilityWeight = .regular, color: Color = .rythmicoForeground) {
            self.string = string
            self.weight = weight
            self.color = color
        }

        init(stringLiteral value: String) {
            self.init(value)
        }
    }
}

extension Array where Element == MultiStyleText.Part {
    var string: String {
        map(\.string).reduce(.empty, +)
    }
}
