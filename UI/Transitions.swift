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

    // TODO: remove, use @Namespace instead.
    static var blendingOpacity: AnyTransition {
        .modifier(
            active: BlendingOpacityModifier(opacity: 0),
            identity: BlendingOpacityModifier(opacity: 1)
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

private struct BlendingOpacityModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    let opacity: Double

    func body(content: Content) -> some View {
        content
            .blendMode(blendMode)
            .opacity(opacity)
    }

    var blendMode: BlendMode {
        colorScheme == .dark ? .plusLighter : .plusDarker
    }
}
