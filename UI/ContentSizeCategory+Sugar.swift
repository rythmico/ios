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
