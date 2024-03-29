import SwiftUIEncore

struct AnalyticsUserProfile {
    var id: String
    var accessibilitySettings: AccessibilitySettings
    var pushNotificationsAuthStatus: PushNotificationAuthorizationCoordinator.Status
    var isCalendarSyncEnabled: Bool
}

extension AnalyticsUserProfile {
    @AnalyticsEvent.PropsBuilder
    var rawAnalyticsValue: AnalyticsEvent.Props {
        [
            "iOS Voice Over Enabled": accessibilitySettings.isVoiceOverOn(),
            "iOS Interface Style": accessibilitySettings.interfaceStyle().rawAnalyticsValue,
            "iOS Dynamic Type Size": accessibilitySettings.dynamicTypeSize().rawAnalyticsValue,
            "iOS Bold Text Enabled": accessibilitySettings.isBoldTextOn(),
        ]
        [
            "iOS Push Notifications Status": pushNotificationsAuthStatus.rawAnalyticsValue,
            "iOS Calendar Sync Enabled": isCalendarSyncEnabled,
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

private extension PushNotificationAuthorizationCoordinator.Status {
    var rawAnalyticsValue: String {
        switch self {
        case .notDetermined:
            return "Not Determined"
        case .authorizing:
            return "Authorizing"
        case .failed:
            return "Failed"
        case .denied:
            return "Denied"
        case .authorized:
            return "Authorized"
        }
    }
}
