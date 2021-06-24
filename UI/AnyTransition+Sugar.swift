import SwiftUI

extension AnyTransition {
    static func + (lhs: AnyTransition, rhs: AnyTransition) -> AnyTransition {
        lhs.combined(with: rhs)
    }
}

// TODO: remove when AnyTransition.move(edge:) respects edgesIgnoringSafeArea.
extension AnyTransition {
    static func move(edgeWithSafeArea edge: Edge) -> AnyTransition {
        move(edge: .bottom).combined(
            with: .offset(
                UIApplication.shared.windows.first?.safeAreaInsets.offset(for: edge) ?? .zero
            )
        )
    }
}
private extension UIEdgeInsets {
    func offset(for edge: Edge) -> CGSize {
        switch edge {
        case .top:
            return .init(width: 0, height: top)
        case .leading:
            return .init(width: left, height: 0)
        case .bottom:
            return .init(width: 0, height: bottom)
        case .trailing:
            return .init(width: right, height: 0)
        }
    }
}
