import SwiftUI
import Sugar

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

        let recognizer = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(didRecognizeEdgeSwipe)
        )
        recognizer.edges = egdes
        recognizer.cancelsTouchesInView = false
        addGestureRecognizer(recognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didRecognizeEdgeSwipe() {
        action()
    }
}
