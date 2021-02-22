import Foundation
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
                    guard let error = error else {
                        preconditionFailure("Failed status should come with error")
                    }
                    completion(.failure(error))
                case .succeeded:
                    guard let setupIntent = setupIntent else {
                        preconditionFailure("Succeeded status should come with setupIntent")
                    }
                    completion(.success(setupIntent))
                @unknown default:
                    fatalError("Unhandled payment setup intent status")
                }
            }
        )
    }
}
