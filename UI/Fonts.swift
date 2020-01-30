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
        let size = textStyle.fontSize * sizeCategory.fontFactor
        let weight = textStyle.weight
        let font = Font.system(size: size, weight: weight, design: .rounded)
        return content.font(font)
    }
}

private extension Font.TextStyle {
    var fontSize: CGFloat {
        switch self {
        case .largeTitle:
            return 33
        case .title:
            return 24
        case .headline:
            return 18
        case .subheadline:
            return 16
        case .body:
            return 15
        case .callout:
            return 15
        case .footnote:
            return 12
        case .caption:
            return 10
        @unknown default:
            return Font.TextStyle.body.fontSize
        }
    }

    var weight: Font.Weight {
        switch self {
        case .largeTitle:
            return .semibold
        case .headline:
            return .semibold
        case .body:
            return .regular
        case .footnote:
            return .semibold
        case .caption:
            return .bold
        default:
            return Font.TextStyle.body.weight
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
            return ContentSizeCategory.medium.fontFactor
        }
    }
}

extension UIFont {
    static func rythmicoFont(_ textStyle: Font.TextStyle) -> UIFont {
        let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: UIFont.Weight(textStyle.weight)]
        let attributes: [UIFontDescriptor.AttributeName: Any] = [.traits: traits]
        let descriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: UIFont.TextStyle(textStyle))
            .addingAttributes(attributes)
            .withDesign(.rounded)!
        return UIFont(descriptor: descriptor, size: textStyle.fontSize)
    }
}

private extension UIFont.TextStyle {
    init(_ textStyle: Font.TextStyle) {
        switch textStyle {
        case .largeTitle:
            self = .largeTitle
        case .title:
            self = .title1
        case .headline:
            self = .headline
        case .subheadline:
            self = .subheadline
        case .body:
            self = .body
        case .callout:
            self = .callout
        case .footnote:
            self = .footnote
        case .caption:
            self = .caption1
        @unknown default:
            self = .body
        }
    }
}

private extension UIFont.Weight {
    init(_ weight: Font.Weight) {
        switch weight {
        case .ultraLight:
            self = .ultraLight
        case .thin:
            self = .thin
        case .light:
            self = .light
        case .regular:
            self = .regular
        case .medium:
            self = .medium
        case .semibold:
            self = .semibold
        case .bold:
            self = .bold
        case .heavy:
            self = .heavy
        case .black:
            self = .black
        default:
            self = .regular
        }
    }
}
