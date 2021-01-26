import SwiftUI

extension AnyTransition {
    // TODO: remove when AnyTransition.move(edge:) respects edgesIgnoringSafeArea.
    static func move(edgeWithSafeArea edge: Edge) -> AnyTransition {
        move(edge: .bottom).combined(
            with: .offset(
                UIApplication.shared.windows[0].safeAreaInsets.offset(for: edge)
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
