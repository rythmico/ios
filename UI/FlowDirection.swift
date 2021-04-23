import SwiftUI

enum FlowDirection {
    case forward, backward
}

extension FlowDirection {
    init?<Step: FlowStep>(from: Step, to: Step) {
        switch true {
        case to.index > from.index: self = .forward
        case to.index < from.index: self = .backward
        default: return nil
        }
    }
}

extension FlowDirection {
    func map<T>(
        forward: @autoclosure () -> T,
        backward: @autoclosure () -> T
    ) -> T {
        switch self {
        case .forward: return forward()
        case .backward: return backward()
        }
    }
}
