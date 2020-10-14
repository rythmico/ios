import Stripe

typealias StripeCardDetails = STPPaymentMethodCardParams

extension StripeCardDetails {
    var isEmpty: Bool {
        return number.isNilOrEmpty
            && expMonth.isNilOrZero
            && expYear.isNilOrZero
            && cvc.isNilOrEmpty
    }
}
