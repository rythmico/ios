import SwiftUI

struct FlowTransition {
    var map: (FlowDirection) -> AnyTransition

    init(_ map: @escaping (FlowDirection) -> AnyTransition) {
        self.map = map
    }

    init(_ transition: AnyTransition) {
        self.map = { _ in transition }
    }
}

extension FlowTransition {
    static var identity = FlowTransition(.identity)
    static var opacity = FlowTransition(.opacity)
    static var scale = FlowTransition(.scale)
    static var slide = move(.horizontal)
}

extension FlowTransition {
    enum Axis {
        case horizontal
        case vertical
    }

    static func move(_ axis: Axis) -> Self {
        FlowTransition { direction in
            switch axis {
            case .horizontal:
                return .asymmetric(
                    insertion: .move(edge: direction.map(forward: .trailing, backward: .leading)),
                    removal: .move(edge: direction.map(forward: .leading, backward: .trailing))
                )
            case .vertical:
                return .asymmetric(
                    insertion: .move(edge: direction.map(forward: .bottom, backward: .top)),
                    removal: .move(edge: direction.map(forward: .top, backward: .bottom))
                )
            }
        }
    }
}

extension FlowTransition {
    func combine(with other: Self) -> Self {
        FlowTransition {
            self.map($0).combined(with: other.map($0))
        }
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        lhs.combine(with: rhs)
    }
}
