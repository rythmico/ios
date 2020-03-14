import Foundation

public extension Error where Self: RawRepresentable, RawValue == String {
    var localizedDescription: String { rawValue }
}
