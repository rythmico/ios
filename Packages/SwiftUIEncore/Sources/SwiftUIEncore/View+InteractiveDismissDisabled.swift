extension View {
    public func interactiveDismissDisabled(_ isDisabled: Bool = true, onAttempt: (() -> Void)? = nil) -> some View {
        introspectViewController {
            guard let presentationController = $0.presentationController else {
                return
            }
            let delegate = AdaptivePresentationControllerDelegate(shouldDismiss: !isDisabled, didAttemptToDismiss: onAttempt)
            controllerDelegateMap.setObject(delegate, forKey: presentationController)
            presentationController.delegate = delegate
        }
    }
}

private final class AdaptivePresentationControllerDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
    let shouldDismiss: Bool
    let didAttemptToDismiss: (() -> Void)?

    init(shouldDismiss: Bool, didAttemptToDismiss: (() -> Void)?) {
        self.shouldDismiss = shouldDismiss
        self.didAttemptToDismiss = didAttemptToDismiss
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        shouldDismiss
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        didAttemptToDismiss?()
    }
}

private var controllerDelegateMap = NSMapTable<UIPresentationController, AdaptivePresentationControllerDelegate>(keyOptions: .weakMemory, valueOptions: .strongMemory)

#if DEBUG
struct AdaptivePresentationView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulView(false, false, 0) { $isPresenting, $isDismissable, $attempts in
            Button("Present") { isPresenting.toggle() }
                .sheet(isPresented: $isPresenting) {
                    HStack {
                        Text("Dismissable (attempted: \(attempts))")
                        Toggle("", isOn: $isDismissable).labelsHidden()
                    }
                    .interactiveDismissDisabled(!isDismissable, onAttempt: { attempts += 1 })
                }
        }
    }
}
#endif
