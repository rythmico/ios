import SwiftUI

struct MultiWeightText: View {
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.legibilityWeight) private var legibilityWeight

    var style: Font.TextStyle
    var parts: [Part]

    var body: some View {
        parts.reduce(Text("")) { text, part in
            text + Text(part.string).font(
                Font.system(
                    size: style.fontSize(for: sizeCategory),
                    weight: weight(for: part, systemLegibilityWeight: legibilityWeight),
                    design: .rounded
                )
            )
        }
        .lineSpacing(6)
    }

    private func weight(for part: Part, systemLegibilityWeight: LegibilityWeight?) -> Font.Weight {
        if systemLegibilityWeight == .bold {
            return part.weight == .bold ? .heavy : .bold
        }
        return style.weight(for: part.weight)
    }
}

extension MultiWeightText {
    enum Part {
        case regular(String)
        case bold(String)

        fileprivate var weight: LegibilityWeight {
            switch self {
            case .regular:
                return .regular
            case .bold:
                return .bold
            }
        }

        fileprivate var string: String {
            switch self {
            case .regular(let string), .bold(let string):
                return string
            }
        }
    }
}
