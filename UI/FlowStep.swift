import SwiftUI

protocol FlowStep {
    typealias Index = Int
    var index: Index { get }

    static var count: Int { get }
}

extension FlowStep where Self: CaseIterable, AllCases.Element: Hashable, AllCases.Index == Index {
    var index: Index {
        guard let index = Self.allCases.firstIndex(of: self) else {
            preconditionFailure("Case '\(type(of: self)).\(self)' not contained within 'CaseIterable.allCases'.")
        }
        return index
    }
}

extension FlowStep where Self: CaseIterable {
    static var count: Int {
        allCases.count
    }
}
