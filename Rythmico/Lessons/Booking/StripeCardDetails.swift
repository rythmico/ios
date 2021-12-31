import Stripe

typealias StripeCardDetails = STPPaymentMethodCardParams

extension StripeCardDetails {
    var isEmpty: Bool {
        return number.isNilOrEmpty
            && (expMonth?.intValue).isNilOrZero
            && (expYear?.intValue).isNilOrZero
            && cvc.isNilOrEmpty
    }
}
