import SwiftUI
import Sugar

struct MultiStyleText: View {
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.legibilityWeight) private var legibilityWeight

    var parts: [Part]
    var alignment: Alignment = .leading

    var body: some View {
        if parts.isEmpty {
            EmptyView()
        } else {
            parts.reduce(Text("")) { text, part in
                text + Text(part.string)
                    .font(
                        .rythmicoFont(
                            part.style,
                            sizeCategory: sizeCategory,
                            legibilityWeight: legibilityWeight
                        )
                    )
                    .foregroundColor(part.color)
            }
            .frame(maxWidth: .infinity, alignment: alignment)
            .lineSpacing(6)
        }
    }
}

extension MultiStyleText {
    struct Part: ExpressibleByStringLiteral {
        var string: String
        var style: RythmicoFontStyle
        var color: Color

        init(_ string: String, style: RythmicoFontStyle = .body, color: Color = .rythmicoForeground) {
            self.string = string
            self.style = style
            self.color = color
        }

        init(stringLiteral value: String) {
            self.init(value)
        }
    }
}

protocol MultiStyleTextPartConvertible {
    var part: MultiStyleText.Part { get }
}

extension String: MultiStyleTextPartConvertible {
    var part: MultiStyleText.Part { .init(self) }
}

extension MultiStyleText.Part: MultiStyleTextPartConvertible {
    var part: MultiStyleText.Part { self }
}

extension MultiStyleTextPartConvertible {
    func style(_ style: RythmicoFontStyle) -> MultiStyleText.Part {
        var part = self.part
        part.style = style
        return part
    }

    func color(_ color: Color) -> MultiStyleText.Part {
        var part = self.part
        part.color = color
        return part
    }
}

extension Array where Element == MultiStyleText.Part {
    static var empty: Self { [] }

    var string: String {
        map(\.string).reduce(.empty, +)
    }
}

typealias MSTP = MultiStyleText.Part

func + (lhs: MSTP, rhs: MSTP) -> [MSTP] { [lhs, rhs] }
func + (lhs: MSTP, rhs: MSTP?) -> [MSTP] { [lhs, rhs].compact() }
func + (lhs: [MSTP], rhs: MSTP) -> [MSTP] { lhs + [rhs] }
func + (lhs: [MSTP], rhs: MSTP?) -> [MSTP] { rhs.map { lhs + [$0] } ?? lhs }
