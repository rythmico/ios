import SwiftUI
import Sugar
import Then

extension View {
    func onBackgroundTapGesture(perform action: @escaping () -> Void) -> some View {
        background(TapView(action: action))
    }
}

struct TapView: UIViewRepresentable {
    var action: Action

    func makeUIView(context: Context) -> UIView {
        TapUIView(action: action)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

private final class TapUIView: UIView, UIGestureRecognizerDelegate {
    var action: Action

    init(action: @escaping Action) {
        self.action = action
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true

        addGestureRecognizer(
            UITapGestureRecognizer().then {
                $0.addTarget(self, action: #selector(didRecognizeTap))
                $0.cancelsTouchesInView = false
                $0.delegate = self
            }
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are doodoo")
    }

    @objc private func didRecognizeTap(recognizer: UIPanGestureRecognizer) {
        guard recognizer.state == .ended else {
            return
        }
        action()
    }
}
