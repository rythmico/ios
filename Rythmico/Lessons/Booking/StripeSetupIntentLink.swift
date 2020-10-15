import SwiftUI
import Stripe
import Sugar

struct StripeSetupIntentLink<Label: View>: View {
    private var credential: CardSetupCredential
    private var cardDetails: StripeCardDetails
    @ObservedObject
    private var coordinator: CardSetupCoordinator
    private var label: (@escaping Action) -> Label
    @State
    private var authenticationView = StripeAuthenticationPresentingView()

    init(
        credential: CardSetupCredential,
        cardDetails: StripeCardDetails,
        coordinator: CardSetupCoordinator,
        @ViewBuilder label: @escaping (@escaping Action) -> Label
    ) {
        self.credential = credential
        self.cardDetails = cardDetails
        self.coordinator = coordinator
        self.label = label
    }

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
