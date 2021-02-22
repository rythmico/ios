import Foundation
import Stripe

struct CardSetupParams {
    var credential: CardSetupCredential
    var cardDetails: StripeCardDetails
    var authenticationContext: STPAuthenticationContext
}

protocol CardSetupServiceProtocol {
    typealias Params = CardSetupParams
    typealias Output = Swift.Result<STPSetupIntentProtocol, Error>?
    typealias Completion = (Output) -> Void
    func send(_ params: Params, completion: @escaping Completion)
}

extension STPPaymentHandler: CardSetupServiceProtocol {
    func send(_ params: Params, completion: @escaping Completion) {
        confirmSetupIntent(
            STPSetupIntentConfirmParams(clientSecret: params.credential.stripeClientSecret).then {
                $0.paymentMethodParams = STPPaymentMethodParams(
                    card: params.cardDetails,
                    billingDetails: nil,
                    metadata: nil
                )
            },
            with: params.authenticationContext,
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
