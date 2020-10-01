import SwiftUI

protocol LegibilityWeightProtocol: Equatable {
    static var bold: Self { get }
    static var regular: Self { get }
}

extension LegibilityWeight: LegibilityWeightProtocol {}
extension UILegibilityWeight: LegibilityWeightProtocol {}
