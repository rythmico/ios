public struct FlowTransition {
    public var map: (FlowDirection) -> AnyTransition

    public init(_ map: @escaping (FlowDirection) -> AnyTransition) {
        self.map = map
    }

    public init(_ transition: AnyTransition) {
        self.map = { _ in transition }
    }
}

extension FlowTransition {
    public static var identity = FlowTransition(.identity)
    public static var opacity = FlowTransition(.opacity)
    public static var scale = FlowTransition(.scale)
    public static var slide = move(.horizontal)
}

extension FlowTransition {
    public enum Axis {
        case horizontal
        case vertical
    }

    public static func move(_ axis: Axis) -> Self {
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
    public func combine(with other: Self) -> Self {
        FlowTransition {
            self.map($0).combined(with: other.map($0))
        }
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.combine(with: rhs)
    }
}
