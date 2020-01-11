import SwiftUI

extension View {
    func rythmicoFont(_ textStyle: Font.TextStyle) -> some View {
        modifier(FontModifier(textStyle: textStyle))
    }
}

struct FontModifier: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    let textStyle: Font.TextStyle

    func body(content: Content) -> some View {
        content.font(.system(size: textStyle.fontSize * sizeCategory.fontFactor))
    }
}

private extension Font.TextStyle {
    var fontSize: CGFloat {
        switch self {
        case .largeTitle:
            return 33
        case .headline:
            return 20
        default:
            // TODO: complete when designs come
            return 17
        }
    }
}

private extension ContentSizeCategory {
    var fontFactor: CGFloat {
        switch self {
        case .extraSmall:
            return 0.8
        case .small:
            return 0.9
        case .medium:
            return 1
        case .large:
            return 1.1
        case .extraLarge:
            return 1.2
        case .extraExtraLarge:
            return 1.3
        case .extraExtraExtraLarge:
            return 1.4
        case .accessibilityMedium:
            return 1.5
        case .accessibilityLarge:
            return 1.6
        case .accessibilityExtraLarge:
            return 1.7
        case .accessibilityExtraExtraLarge:
            return 1.8
        case .accessibilityExtraExtraExtraLarge:
            return 1.9
        @unknown default:
            return 1
        }
    }
}
