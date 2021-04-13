import SwiftUI
import FoundationSugar

extension Text {
    func rythmicoTextStyle(_ style: Font.RythmicoTextStyle) -> some View {
        self.font(.rythmico(style))
            .tracking(style.tracking)
            .lineSpacing(style.lineSpacing)
    }
}

extension Text {
    func rythmicoFontWeight(_ style: Font.RythmicoTextStyle) -> Text {
        self.fontWeight(style.weight)
    }
}

extension Image {
    func rythmicoFont(_ style: Font.RythmicoTextStyle) -> some View {
        self.font(.rythmico(style))
    }
}

extension Font {
    enum RythmicoTextStyle {
        fileprivate enum FamilyName {
            static let notoSansJP = "Noto Sans JP"
        }

        case largeTitle         // 32px Black
        case headline           // 20px Black
        case subheadlineBold    // 18px Black
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

        fileprivate var regularSize: CGFloat {
            switch self {
            case .largeTitle:
                return 32
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
            case .largeTitle: return .black
            case .headline: return .black
            case .subheadlineBold: return .black
            case .subheadline: return .regular
            case .bodyBold: return .bold
            case .bodySemibold: return .semibold
            case .bodyMedium: return .medium
            case .body: return .regular
            case .calloutBold: return .bold
            case .callout: return .regular
            case .footnoteBold: return .bold
            case .footnote: return .regular
            case .caption: return .bold
            }
        }

        var weight: Font.Weight {
            UIAccessibility.isBoldTextEnabled ? regularWeight.bolder : regularWeight
        }

        var tracking: CGFloat {
            switch self {
            case .largeTitle:
                return -0.8
            case .headline, .subheadlineBold, .subheadline:
                return -0.2
            case .bodyBold, .bodySemibold, .bodyMedium, .body:
                return 0
            case .calloutBold, .callout:
                return 0
            case .footnoteBold, .footnote:
                return 0
            case .caption:
                return 0.4
            }
        }

        var lineSpacing: CGFloat {
            switch self {
            case .largeTitle,
                 .headline,
                 .subheadlineBold,
                 .subheadline,
                 .bodyBold,
                 .bodySemibold,
                 .bodyMedium,
                 .body:
                return .spacingUnit
            case .calloutBold,
                 .callout:
                return .spacingUnit / 2
            case .footnoteBold,
                 .footnote,
                 .caption:
                return .spacingUnit
            }
        }
    }
}

private extension Font.Weight {
    var bolder: Self {
        switch self {
        case .regular:
            return .medium
        case .medium, .semibold:
            return .bold
        case .bold, .heavy, .black:
            return .black
        default:
            return .bold
        }
    }
}

extension Font {
    static func rythmico(_ style: RythmicoTextStyle) -> Font {
        .custom(RythmicoTextStyle.FamilyName.notoSansJP, size: style.regularSize, relativeTo: .largeTitle).weight(style.weight)
    }
}

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    @DictionaryBuilder<Key, Value>
    static func rythmicoTextAttributes(color: UIColor?, style: Font.RythmicoTextStyle) -> Self {
        [.foregroundColor: color].compact()
        [.font: UIFont.rythmicoFont(style)]
        [.tracking: style.tracking]
    }
}

extension UIFont {
    static func rythmicoFont(_ style: Font.RythmicoTextStyle) -> UIFont {
        UIFontMetrics(forTextStyle: .largeTitle).scaledFont(
            for: UIFont(
                descriptor: UIFontDescriptor(
                    fontAttributes: [
                        .family: Font.RythmicoTextStyle.FamilyName.notoSansJP,
                        .traits: [ UIFontDescriptor.TraitKey.weight: Weight(style.weight).rawValue ],
                    ]
                ),
                size: style.regularSize
            ),
            maximumPointSize: 40
        )
    }
}

private extension UIFont.Weight {
    init(_ weight: Font.Weight) {
        switch weight {
        case .ultraLight: self = .ultraLight
        case .thin: self = .thin
        case .light: self = .light
        case .regular: self = .regular
        case .medium: self = .medium
        case .semibold: self = .semibold
        case .bold: self = .bold
        case .heavy: self = .heavy
        case .black: self = .black
        default: self = .regular
        }
    }
}
