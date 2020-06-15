import SwiftUI

extension View {
    func rythmicoFont(_ style: RythmicoFontStyle) -> some View {
        modifier(FontModifier(style: style))
    }
}

struct FontModifier: ViewModifier {
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.legibilityWeight) private var legibilityWeight

    let style: RythmicoFontStyle

    func body(content: Content) -> some View {
        content.font(
            .rythmicoFont(style, sizeCategory: sizeCategory, legibilityWeight: legibilityWeight)
        )
    }
}

enum RythmicoFontStyle {
    case largeTitle         // 28px Bold
//    case title
    case headline           // 20px Bold
    case subheadlineBold    // 18px Bold
    case subheadline        // 18px Regular
    case bodyBold           // 16px Bold
    case bodySemibold       // 16px Semibold
    case bodyMedium         // 16px Medium
    case body               // 16px Regular
    case calloutBold        // 14px Bold
    case callout            // 14px Regular
    case footnoteBold       // 12px Bold
    case footnote           // 12px Regular
    case caption            // 10px Bold

    private var regularSize: CGFloat {
        switch self {
        case .largeTitle:
            return 28
        case .headline:
            return 20
        case .subheadlineBold, .subheadline:
            return 18
        case .bodyBold, .bodySemibold, .bodyMedium, .body:
            return 16
        case .calloutBold, .callout:
            return 14
        case .footnoteBold, .footnote:
            return 12
        case .caption:
            return 10
        }
    }

    private var regularWeight: Font.Weight {
        switch self {
        case .largeTitle:
            return .bold
        case .headline:
            return .bold
        case .subheadlineBold:
            return .bold
        case .subheadline:
            return .regular
        case .bodyBold:
            return .bold
        case .bodySemibold:
            return .semibold
        case .bodyMedium:
            return .medium
        case .body:
            return .regular
        case .calloutBold:
            return .bold
        case .callout:
            return .regular
        case .footnoteBold:
            return .bold
        case .footnote:
            return .regular
        case .caption:
            return .bold
        }
    }

    fileprivate func size(for sizeCategory: ContentSizeCategory) -> CGFloat {
        regularSize * sizeCategory.sizeFactor
    }

    fileprivate func weight(for legibilityWeight: LegibilityWeight?) -> Font.Weight {
        legibilityWeight == .bold ? regularWeight.bolder : regularWeight
    }
}

extension ContentSizeCategory {
    var sizeFactor: CGFloat {
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
            return ContentSizeCategory.medium.sizeFactor
        }
    }
}

private extension Font.Weight {
    var bolder: Font.Weight {
        switch self {
        case .regular:
            return .medium
        case .medium:
            return .semibold
        case .semibold:
            return .bold
        case .bold:
            return .heavy
        case .heavy, .black:
            return .black
        default:
            return .semibold
        }
    }
}

extension Font {
    static func rythmicoFont(
        _ style: RythmicoFontStyle,
        sizeCategory: ContentSizeCategory,
        legibilityWeight: LegibilityWeight?
    ) -> Font {
        Font.system(
            size: style.size(for: sizeCategory),
            weight: style.weight(for: legibilityWeight),
            design: .rounded
        )
    }
}

extension UIFont {
    static func rythmicoFont(_ style: RythmicoFontStyle) -> UIFont {
        let sizeCategory = ContentSizeCategory(UITraitCollection.current.preferredContentSizeCategory)
        let legibilityWeight = LegibilityWeight(UITraitCollection.current.legibilityWeight)

        let fontSize = style.size(for: sizeCategory)
        let fontWeight = UIFont.Weight(style.weight(for: legibilityWeight))
        let baseFont = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let descriptor = baseFont.fontDescriptor.withDesign(.rounded)!

        return UIFont(descriptor: descriptor, size: fontSize)
    }
}

// Replace with enum protocol extension (Swift 5.3 onwards).
private extension ContentSizeCategory {
    init(_ contentSizeCategory: UIContentSizeCategory) {
        switch contentSizeCategory {
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

// Replace with enum protocol extension (Swift 5.3 onwards).
private extension LegibilityWeight {
    init?(_ legibilityWeight: UILegibilityWeight) {
        switch legibilityWeight {
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
