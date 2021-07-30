import SwiftUISugar

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
            static let dmSans = "DM Sans"
        }

        case largeTitle         // 32px Bold
        case headline           // 22px Bold
        case subheadlineBold    // 19px Bold
        case subheadlineMedium  // 19px Medium
        case subheadline        // 19px Regular
        case bodyBold           // 17px Bold
        case bodySemibold       // 17px Semibold
        case bodyMedium         // 17px Medium
        case body               // 17px Regular
        case calloutBold        // 15px Bold
        case callout            // 15px Regular
        case footnoteBold       // 13px Bold
        case footnote           // 13px Regular
        case caption            // 11px Bold

        fileprivate var regularSize: CGFloat {
            switch self {
            case .largeTitle:
                return 32
            case .headline:
                return 22
            case .subheadlineBold, .subheadlineMedium, .subheadline:
                return 19
            case .bodyBold, .bodySemibold, .bodyMedium, .body:
                return 17
            case .calloutBold, .callout:
                return 15
            case .footnoteBold, .footnote:
                return 13
            case .caption:
                return 11
            }
        }

        private var regularWeight: Font.Weight {
            switch self {
            case .largeTitle: return .bold
            case .headline: return .bold
            case .subheadlineBold: return .bold
            case .subheadlineMedium: return .medium
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
            case .headline:
                return -0.2
            case .subheadlineBold, .subheadlineMedium, .subheadline:
                return -0.2
            case .bodyBold, .bodySemibold, .bodyMedium, .body:
                return -0.4
            case .calloutBold, .callout:
                return 0
            case .footnoteBold, .footnote:
                return 0
            case .caption:
                return 0.4
            }
        }

        var lineSpacing: CGFloat {
            .grid(1)
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
        .custom(RythmicoTextStyle.FamilyName.dmSans, size: style.regularSize, relativeTo: .largeTitle).weight(style.weight)
    }
}

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    @DictionaryBuilder<Key, Value>
    static func rythmicoTextAttributes(color: UIColor?, style: Font.RythmicoTextStyle) -> Self {
        [.foregroundColor: color].compact()
        [.font: UIFont.rythmicoFont(style)]
        [.tracking: style.tracking]
        [.paragraphStyle: NSMutableParagraphStyle().with {
            $0.lineSpacing = style.lineSpacing
            $0.paragraphSpacing = .grid(4)
        }]
    }
}

extension UIFont {
    static func rythmicoFont(_ style: Font.RythmicoTextStyle) -> UIFont {
        UIFontMetrics(forTextStyle: .largeTitle).scaledFont(
            for: UIFont(
                descriptor: UIFontDescriptor(
                    fontAttributes: [
                        .family: Font.RythmicoTextStyle.FamilyName.dmSans,
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
