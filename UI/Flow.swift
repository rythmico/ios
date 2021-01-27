import SwiftUI

protocol Numbered: Comparable {
    var index: Int { get }
}

extension Numbered {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.index < rhs.index
    }
}

extension Numbered where Self: CaseIterable, AllCases.Element: Hashable, AllCases: RandomAccessCollection, AllCases.Index == Int {
    var index: Int {
        guard let n = Self.allCases.firstIndex(of: self) else {
            preconditionFailure("Case '\(type(of: self)).\(self)' not contained within 'CaseIterable.allCases'.")
        }
        return n
    }
}

protocol Countable {
    static var count: Int { get }
}

extension Countable where Self: CaseIterable {
    static var count: Int {
        allCases.count
    }
}

protocol Flow: ObservableObject {
    associatedtype Step: Numbered, Countable
    var previousStep: Step? { get }
    var currentStep: Step { get }
}
