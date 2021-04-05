import SwiftUI
import FoundationSugar

@available(*, deprecated)
struct MultiStyleText: View {
    var parts: [Part]
    var expanded: Bool = true
    var alignment: Alignment = .leading
    var foregroundColor: Color = .rythmicoForeground

    var body: some View {
        if parts.isEmpty {
            EmptyView()
        } else {
            parts.reduce(Text("")) { text, part in
                text + Text(part.string)
                    .rythmicoFont(part.style ?? .body)
                    .foregroundColor(part.color ?? foregroundColor)
            }
            .frame(maxWidth: expanded ? .infinity : nil, alignment: alignment)
            .lineSpacing(6)
        }
    }
}

extension MultiStyleText {
    struct Part: ExpressibleByStringLiteral {
        var string: String
        var style: Font.RythmicoTextStyle?
        var color: Color?

        init(_ string: String, style: Font.RythmicoTextStyle? = nil, color: Color? = nil) {
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
    func style(_ style: Font.RythmicoTextStyle?) -> MultiStyleText.Part {
        var part = self.part
        part.style = style
        return part
    }

    func color(_ color: Color?) -> MultiStyleText.Part {
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
