import SwiftUI
import Sugar
import Then

extension View {
    func onEdgeSwipe(edges: UIRectEdge, perform action: @escaping () -> Void) -> some View {
        background(EdgeSwipeView(egdes: edges, action: action))
    }
}

struct EdgeSwipeView: UIViewRepresentable {
    var egdes: UIRectEdge
    var action: Action

    func makeUIView(context: Context) -> UIView {
        EdgeSwipeUIView(egdes: egdes, action: action)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

private final class EdgeSwipeUIView: UIView {
    var action: Action

    init(egdes: UIRectEdge, action: @escaping Action) {
        self.action = action
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true

        addGestureRecognizer(
            UIScreenEdgePanGestureRecognizer().then {
                $0.addTarget(self, action: #selector(didRecognizeEdgeSwipe))
                $0.edges = egdes
                $0.cancelsTouchesInView = false
            }
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are doodoo")
    }

    @objc private func didRecognizeEdgeSwipe() {
        action()
    }
}
