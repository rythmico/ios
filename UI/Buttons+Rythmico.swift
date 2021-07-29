import SwiftUISugar

struct RythmicoButton<Title: StringProtocol, Style: RythmicoButtonStyleProtocol>: View {
    var title: Title
    var style: Style
    var action: Action?

    init(_ title: Title, style: Style, action: Action?) {
        self.title = title
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action ?? {}) {
            Text(title).rythmicoTextStyle(Style.textStyle)
        }
        .buttonStyle(style)
    }
}

protocol RythmicoButtonStyleProtocol: ButtonStyle {
    static var textStyle: Font.RythmicoTextStyle { get }
}

// TODO: uncomment in Swift 5.5
//extension RythmicoButtonStyleProtocol where Self == RythmicoButtonStyle {
extension RythmicoButtonStyle {
    static func primary(layout: RythmicoButtonStyleLayout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            foregroundColor: (normal: .rythmico.white, pressed: .rythmico.white),
            backgroundColor: (normal: .rythmico.purple, pressed: .rythmico.highlightPurple),
            borderColor: (normal: .clear, pressed: .clear)
        )
    }

    static func secondary(layout: RythmicoButtonStyleLayout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            foregroundColor: (normal: .rythmico.purple, pressed: .rythmico.white),
            backgroundColor: (normal: .clear, pressed: .rythmico.purple),
            borderColor: (normal: .rythmico.purple, pressed: .rythmico.purple)
        )
    }

    static func tertiary(layout: RythmicoButtonStyleLayout = .expansive) -> RythmicoButtonStyle {
        RythmicoButtonStyle(
            layout: layout,
            foregroundColor: (normal: .rythmico.foreground, pressed: .rythmico.white),
            backgroundColor: (normal: .clear, pressed: .rythmico.gray30),
            borderColor: (normal: .rythmico.gray30, pressed: .rythmico.gray30)
        )
    }
}

// TODO: uncomment in Swift 5.5
//extension RythmicoButtonStyleProtocol where Self == RythmicoLinkButtonStyle {
extension RythmicoLinkButtonStyle {
    static func quaternary(expansive: Bool = true) -> RythmicoLinkButtonStyle {
        RythmicoLinkButtonStyle(expansive: expansive)
    }
}

enum RythmicoButtonStyleLayout: Equatable {
    enum ConstrainedSize: Equatable {
        case small
        case medium
    }
    case expansive
    case contrained(ConstrainedSize)
}

struct RythmicoButtonStyle: RythmicoButtonStyleProtocol {
    static var textStyle: Font.RythmicoTextStyle { .bodyBold }

    typealias StateColors = (normal: Color, pressed: Color)

    var layout: RythmicoButtonStyleLayout
    let buttonMaxWidth: CGFloat = .grid(85)
    var foregroundColor: StateColors
    var backgroundColor: StateColors
    var borderColor: StateColors

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, .grid(5))
            .foregroundColor(color(from: foregroundColor, for: configuration))
            .frame(maxWidth: maxWidth, minHeight: minHeight)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(color(from: backgroundColor, for: configuration))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(color(from: borderColor, for: configuration), lineWidth: 2)
                    )
                    .contentShape(Rectangle())
            )
            .modifier(DiseableableButtonModifier())
    }

    var maxWidth: CGFloat? {
        layout == .expansive ? buttonMaxWidth : nil
    }

    var minHeight: CGFloat {
        switch layout {
        case .expansive, .contrained(.medium):
            return 48
        case .contrained(.small):
            return 38
        }
    }

    func color(from colors: StateColors, for configuration: Configuration) -> Color {
        configuration.isPressed ? colors.pressed : colors.normal
    }
}

struct RythmicoLinkButtonStyle: RythmicoButtonStyleProtocol {
    static var textStyle: Font.RythmicoTextStyle { .body }

    var expansive: Bool
    let buttonMaxWidth: CGFloat = .grid(85)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.rythmico.foreground)
            .opacity(configuration.isPressed ? 0.3 : 1)
            .frame(maxWidth: expansive ? buttonMaxWidth : nil, minHeight: 48)
            .modifier(DiseableableButtonModifier())
            .contentShape(Rectangle())
    }
}

private struct DiseableableButtonModifier: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isEnabled ? 1 : 0.3)
            .animation(.easeInOut(duration: .durationShort), value: isEnabled)
    }
}

#if DEBUG
struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: .grid(4)) {
                RythmicoButton("Next", style: RythmicoButtonStyle.primary(layout: .contrained(.small)), action: {})
                RythmicoButton("Next", style: RythmicoButtonStyle.primary(layout: .contrained(.medium)), action: {})
                RythmicoButton("Next", style: RythmicoButtonStyle.primary(), action: {})
                RythmicoButton("Next", style: RythmicoButtonStyle.primary(), action: {}).disabled(true)
            }

            VStack(spacing: .grid(4)) {
                RythmicoButton("Next", style: RythmicoButtonStyle.secondary(layout: .contrained(.small)), action: {})
                RythmicoButton("Next", style: RythmicoButtonStyle.secondary(layout: .contrained(.medium)), action: {})
                RythmicoButton("Next", style: RythmicoButtonStyle.secondary(), action: {})
                RythmicoButton("Next", style: RythmicoButtonStyle.secondary(), action: {}).disabled(true)
            }

            VStack(spacing: .grid(4)) {
                RythmicoButton("Next", style: RythmicoButtonStyle.tertiary(layout: .contrained(.small)), action: {})
                RythmicoButton("Next", style: RythmicoButtonStyle.tertiary(layout: .contrained(.medium)), action: {})
                RythmicoButton("Next", style: RythmicoButtonStyle.tertiary(), action: {})
                RythmicoButton("Next", style: RythmicoButtonStyle.tertiary(), action: {}).disabled(true)
            }

            VStack(spacing: .grid(4)) {
                RythmicoButton("Next", style: RythmicoLinkButtonStyle.quaternary(expansive: false), action: {})
                RythmicoButton("Next", style: RythmicoLinkButtonStyle.quaternary(), action: {})
                RythmicoButton("Next", style: RythmicoLinkButtonStyle.quaternary(), action: {}).disabled(true)
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
