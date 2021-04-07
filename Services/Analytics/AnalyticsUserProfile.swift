import UIKit
import FoundationSugar

struct AnalyticsUserProfile {
    var id: String
    var name: String?
    var email: String?
    var accessibilitySettings: AccessibilitySettings
}

extension AnalyticsUserProfile {
    @AnalyticsPropsBuilder
    var rawAnalyticsValue: AnalyticsProps {
        if let name = name?.nilIfEmpty {
            ["$name": name]
        }
        if let email = email?.nilIfEmpty {
            ["$email": email]
        }
        [
            "Voice Over Enabled": accessibilitySettings.isVoiceOverOn(),
            "Interface Style": accessibilitySettings.interfaceStyle().rawAnalyticsValue,
            "Dynamic Type Size": accessibilitySettings.dynamicTypeSize().rawAnalyticsValue,
            "Bold Text Enabled": accessibilitySettings.isBoldTextOn(),
        ]
    }
}

private extension UIUserInterfaceStyle {
    var rawAnalyticsValue: String {
        switch self {
        case .dark:
            return "Dark"
        case .light:
            return "Light"
        case .unspecified:
            return .empty
        @unknown default:
            return .empty
        }
    }
}

private extension UIContentSizeCategory {
    var rawAnalyticsValue: String {
        switch self {
        case .extraSmall:
            return "XS"
        case .small:
            return "S"
        case .medium:
            return "M"
        case .large:
            return "L"
        case .extraLarge:
            return "XL"
        case .extraExtraLarge:
            return "2XL"
        case .extraExtraExtraLarge:
            return "3XL"
        case .accessibilityMedium:
            return "4XL"
        case .accessibilityLarge:
            return "5XL"
        case .accessibilityExtraLarge:
            return "6XL"
        case .accessibilityExtraExtraLarge:
            return "7XL"
        case .accessibilityExtraExtraExtraLarge:
            return "8XL"
        default:
            return .empty
        }
    }
}
