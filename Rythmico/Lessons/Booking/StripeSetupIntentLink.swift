import SwiftUIEncore
import Stripe

struct StripeSetupIntentLink<Label: View>: View {
    var credential: CardSetupCredential
    var cardDetails: StripeCardDetails
    @ObservedObject
    var coordinator: CardSetupCoordinator
    @ViewBuilder
    var label: (@escaping Action) -> Label
    @State
    private var authenticationView = StripeAuthenticationPresentingView()

    var body: some View {
        ZStack {
            authenticationView.frame(width: 0, height: 0)
            label(confirmSetupIntent).disabled(coordinator.state.isLoading)
        }
    }

    private func confirmSetupIntent() {
        coordinator.start(
            with: CardSetupParams(
                credential: credential,
                cardDetails: cardDetails,
                authenticationContext: authenticationView.authenticationContext
            )
        )
    }
}

private struct StripeAuthenticationPresentingView: UIViewControllerRepresentable {
    final class AuthenticationContext: UIViewController, STPAuthenticationContext {
        func authenticationPresentingViewController() -> UIViewController { self }
    }

    let authenticationContext = AuthenticationContext()

    func makeUIViewController(context: Context) -> AuthenticationContext { authenticationContext }
    func updateUIViewController(_ uiViewController: AuthenticationContext, context: Context) {}
}
