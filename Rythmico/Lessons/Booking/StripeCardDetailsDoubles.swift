import FoundationEncore

extension StripeCardDetails {
    static let stub = StripeCardDetails() => {
        $0.number = "4000002500003155"
        $0.expMonth = 3
        $0.expYear = 22
        $0.cvc = "234"
    }
}
