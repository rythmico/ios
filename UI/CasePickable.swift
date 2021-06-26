import SwiftUI

protocol CasePickable {
    associatedtype PickableCases: Collection where PickableCases.Element == Self
    static var pickableCases: PickableCases { get }
}

extension CasePickable where Self: CaseIterable, PickableCases == AllCases {
    static var pickableCases: PickableCases { allCases }
}
