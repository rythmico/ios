import SwiftUI

extension View {
    func rythmicoFont(_ textStyle: Font.TextStyle) -> some View {
        modifier(FontModifier(textStyle: textStyle))
    }
}

struct FontModifier: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.legibilityWeight) var legibilityWeight

    let textStyle: Font.TextStyle

    func body(content: Content) -> some View {
        let size = textStyle.fontSize(for: sizeCategory)
        let weight = textStyle.weight(for: legibilityWeight)
        let font = Font.system(size: size, weight: weight, design: .rounded)
        return content.font(font)
    }
}

extension Font.TextStyle {
    func fontSize(for sizeCategory: ContentSizeCategory) -> CGFloat {
        regularFontSize * sizeCategory.fontFactor
    }

    private var regularFontSize: CGFloat {
        switch self {
        case .largeTitle:
            return 28
        case .title:
            return 24
        case .headline:
            return 18
        case .subheadline:
            return 17
        case .body:
            return 16
        case .callout:
            return 16
        case .footnote:
            return 11
        case .caption:
            return 10
        @unknown default:
            return Font.TextStyle.body.regularFontSize
        }
    }

    func weight(for legibilityWeight: LegibilityWeight?) -> Font.Weight {
        switch self {
        case .largeTitle:
            return legibilityWeight == .bold ? .black : .bold
        case .headline:
            return legibilityWeight == .bold ? .heavy : .bold
        case .subheadline:
            return legibilityWeight == .bold ? .heavy : .semibold
        case .body:
            return legibilityWeight == .bold ? .bold : .regular
        case .callout:
            return legibilityWeight == .bold ? .heavy : .bold
        case .footnote:
            return legibilityWeight == .bold ? .black : .bold
        case .caption:
            return legibilityWeight == .bold ? .black : .bold
        default:
            return Font.TextStyle.body.weight(for: legibilityWeight)
        }
    }
}

private extension ContentSizeCategory {
    var fontFactor: CGFloat {
        switch self {
        case .extraSmall:
            return 0.95
        case .small:
            return 0.975
        case .medium:
            return 1
        case .large:
            return 1.1
        case .extraLarge:
            return 1.2
        case .extraExtraLarge:
            return 1.3
        case .extraExtraExtraLarge:
            return 1.45
        case .accessibilityMedium:
            return 1.5
        case .accessibilityLarge:
            return 1.55
        case .accessibilityExtraLarge:
            return 1.55
        case .accessibilityExtraExtraLarge:
            return 1.55
        case .accessibilityExtraExtraExtraLarge:
            return 1.55
        @unknown default:
            return ContentSizeCategory.medium.fontFactor
        }
    }
}

extension UIFont {
    static func rythmicoFont(_ textStyle: Font.TextStyle) -> UIFont {
        let contentSizeCategory = ContentSizeCategory(UITraitCollection.current.preferredContentSizeCategory)
        let legibilityWeight = LegibilityWeight(UITraitCollection.current.legibilityWeight)
        let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: UIFont.Weight(textStyle.weight(for: legibilityWeight))]
        let attributes: [UIFontDescriptor.AttributeName: Any] = [.traits: traits]
        let descriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: UIFont.TextStyle(textStyle))
            .addingAttributes(attributes)
            .withDesign(.rounded)!
        return UIFont(descriptor: descriptor, size: textStyle.fontSize(for: contentSizeCategory))
    }
}

private extension ContentSizeCategory {
    init(_ uiContentSizeCategory: UIContentSizeCategory) {
        switch uiContentSizeCategory {
        case .extraSmall:
            self = .extraSmall
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        case .extraLarge:
            self = .extraLarge
        case .extraExtraLarge:
            self = .extraExtraLarge
        case .extraExtraExtraLarge:
            self = .extraExtraExtraLarge
        case .accessibilityMedium:
            self = .accessibilityMedium
        case .accessibilityLarge:
            self = .accessibilityLarge
        case .accessibilityExtraLarge:
            self = .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge:
            self = .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge:
            self = .accessibilityExtraExtraExtraLarge
        default:
            self = .medium
        }
    }
}

private extension LegibilityWeight {
    init?(_ uiLegibilityWeight: UILegibilityWeight) {
        switch uiLegibilityWeight {
        case .bold:
            self = .bold
        case .regular:
            self = .regular
        case .unspecified:
            return nil
        @unknown default:
            return nil
        }
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
