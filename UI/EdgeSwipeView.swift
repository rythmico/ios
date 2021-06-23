import SwiftUI
import FoundationSugar

extension View {
    func onEdgeSwipe(_ edge: EdgeSwipeView.Edge, perform action: @escaping () -> Void) -> some View {
        background(EdgeSwipeView(edge: edge, action: action))
    }
}

struct EdgeSwipeView: UIViewRepresentable {
    enum Edge {
        case left, right
    }

    var edge: Edge
    var action: Action

    func makeUIView(context: Context) -> UIView {
        EdgeSwipeUIView(edge: edge, action: action)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

private final class EdgeSwipeUIView: UIView, UIGestureRecognizerDelegate {
    var edge: EdgeSwipeView.Edge
    var action: Action

    init(edge: EdgeSwipeView.Edge, action: @escaping Action) {
        self.edge = edge
        self.action = action
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true

        addGestureRecognizer(
            UIPanGestureRecognizer().then {
                $0.addTarget(self, action: #selector(didRecognizeEdgeSwipe))
                $0.cancelsTouchesInView = false
                $0.delegate = self
            }
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are doodoo")
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        initialPosition = touch.location(in: gestureRecognizer.view).x
        return true
    }

    @objc private func didRecognizeEdgeSwipe(recognizer: UIPanGestureRecognizer) {
        guard
            let initialPosition = initialPosition,
            let viewWidth = recognizer.view?.frame.width,
            recognizer.state == .changed
        else {
            return
        }

        let initialMargin = edge == .left ? initialPosition : viewWidth - initialPosition
        guard initialMargin <= 20 else { return }

        let currentPosition = recognizer.location(in: recognizer.view).x
        let currentMargin = edge == .left ? currentPosition : viewWidth - currentPosition
        guard currentMargin >= 70 else { return }

        self.initialPosition = nil
        action()
    }

    private var initialPosition: CGFloat?
}
