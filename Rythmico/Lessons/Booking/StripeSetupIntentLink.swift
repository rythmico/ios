import SwiftUI
import Stripe
import Sugar

struct StripeSetupIntentLink<Label: View>: View {
    private var clientSecret: String
    private var cardDetails: StripeCardDetails
    @ObservedObject
    private var coordinator: AddNewCardCoordinator
    private var label: (@escaping Action) -> Label
    @State
    private var authenticationView = StripeAuthenticationPresentingView()

    init(
        clientSecret: String,
        cardDetails: StripeCardDetails,
        coordinator: AddNewCardCoordinator,
        @ViewBuilder label: @escaping (@escaping Action) -> Label
    ) {
        self.clientSecret = clientSecret
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
            with: AddNewCardServiceParams(
                clientSecret: clientSecret,
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
