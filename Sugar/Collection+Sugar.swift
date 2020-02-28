import Foundation

extension Collection {
    public var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}
