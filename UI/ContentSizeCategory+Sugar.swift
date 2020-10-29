import SwiftUI

protocol ContentSizeCategoryProtocol: Equatable {
    static var extraSmall: Self { get }
    static var small: Self { get }
    static var medium: Self { get }
    static var large: Self { get }
    static var extraLarge: Self { get }
    static var extraExtraLarge: Self { get }
    static var extraExtraExtraLarge: Self { get }
    static var accessibilityMedium: Self { get }
    static var accessibilityLarge: Self { get }
    static var accessibilityExtraLarge: Self { get }
    static var accessibilityExtraExtraLarge: Self { get }
    static var accessibilityExtraExtraExtraLarge: Self { get }
}

extension ContentSizeCategoryProtocol {
    static var `default`: Self { .medium }
}

extension ContentSizeCategoryProtocol {
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
        default:
            return Self.default.sizeFactor
        }
    }
}

extension ContentSizeCategory: ContentSizeCategoryProtocol {}
extension UIContentSizeCategory: ContentSizeCategoryProtocol {}
