import SwiftUI

extension View {
    func sheetInteractiveDismissal(_ enabled: Bool, onAttempt: (() -> Void)? = nil) -> some View {
        AdaptivePresentationView(view: self, isInteractiveDismissalEnabled: enabled, onDismissalAttempt: onAttempt)
    }
}

private struct AdaptivePresentationView<T: View>: UIViewControllerRepresentable {
    let view: T
    let isInteractiveDismissalEnabled: Bool
    let onDismissalAttempt: (() -> Void)?

    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: view)
    }

    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {
        uiViewController.parent?.presentationController?.delegate = context.coordinator
        uiViewController.rootView = view
        context.coordinator.adaptivePresentationView = self
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var adaptivePresentationView: AdaptivePresentationView

        init(_ adaptivePresentationView: AdaptivePresentationView) {
            self.adaptivePresentationView = adaptivePresentationView
        }

        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            adaptivePresentationView.isInteractiveDismissalEnabled
        }

        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            adaptivePresentationView.onDismissalAttempt?()
        }
    }
}
