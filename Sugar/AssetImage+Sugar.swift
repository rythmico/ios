import Foundation

extension ImageAsset: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}
