import FoundationSugar
import Stripe

struct CardSetupParams {
    var credential: CardSetupCredential
    var cardDetails: StripeCardDetails
    var authenticationContext: STPAuthenticationContext
}

protocol CardSetupServiceProtocol {
    typealias Input = CardSetupParams
    typealias Output = Swift.Result<STPSetupIntentProtocol, Error>?
    typealias Completion = (Output) -> Void
    func send(_ input: Input, completion: @escaping Completion)
}

extension STPPaymentHandler: CardSetupServiceProtocol {
    func send(_ input: Input, completion: @escaping Completion) {
        confirmSetupIntent(
            STPSetupIntentConfirmParams(clientSecret: input.credential.stripeClientSecret).then {
                $0.paymentMethodParams = STPPaymentMethodParams(
                    card: input.cardDetails,
                    billingDetails: nil,
                    metadata: nil
                )
            },
            with: input.authenticationContext,
            completion: { status, setupIntent, error in
                switch status {
                case .canceled:
                    completion(nil)
                case .failed:
                    completion(.failure(error !! preconditionFailure("Failed status should come with error")))
                case .succeeded:
                    completion(.success(setupIntent !! preconditionFailure("Succeeded status should come with setupIntent")))
                @unknown default:
                    fatalError("Unhandled payment setup intent status")
                }
            }
        )
    }
}
