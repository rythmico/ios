import SwiftUI

extension ContentSizeCategory {
    // TODO: remove after obsoleting iOS 13
    var _isAccessibilityCategory: Bool {
        switch self {
        case .accessibilityMedium,
             .accessibilityLarge,
             .accessibilityExtraLarge,
             .accessibilityExtraExtraLarge,
             .accessibilityExtraExtraExtraLarge:
            return true
        case .extraSmall,
             .small,
             .medium,
             .large,
             .extraLarge,
             .extraExtraLarge,
             .extraExtraExtraLarge:
            return false
        @unknown default:
            return false
        }
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
