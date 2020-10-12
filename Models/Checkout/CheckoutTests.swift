import XCTest
@testable import Rythmico
import Stripe

final class CheckoutTests: XCTestCase {
    func testCardBrandParsing() {
        XCTAssertEqual(Checkout.Card.Brand("visa"), .visa)
        XCTAssertEqual(Checkout.Card.Brand("Visa"), .visa)

        XCTAssertEqual(Checkout.Card.Brand("amex"), .amex)
        XCTAssertEqual(Checkout.Card.Brand("Amex"), .amex)

        XCTAssertEqual(Checkout.Card.Brand("mastercard"), .masterCard)
        XCTAssertEqual(Checkout.Card.Brand("Mastercard"), .masterCard)

        XCTAssertEqual(Checkout.Card.Brand("discover"), .discover)
        XCTAssertEqual(Checkout.Card.Brand("Discover"), .discover)

        XCTAssertEqual(Checkout.Card.Brand("jcb"), .JCB)
        XCTAssertEqual(Checkout.Card.Brand("JCB"), .JCB)

        XCTAssertEqual(Checkout.Card.Brand("diners"), .dinersClub)
        XCTAssertEqual(Checkout.Card.Brand("Diners"), .dinersClub)

        XCTAssertEqual(Checkout.Card.Brand("unionpay"), .unionPay)
        XCTAssertEqual(Checkout.Card.Brand("Unionpay"), .unionPay)

        XCTAssertEqual(Checkout.Card.Brand("unknown"), .unknown)
        XCTAssertEqual(Checkout.Card.Brand("Unknown"), .unknown)
        XCTAssertEqual(Checkout.Card.Brand("blabla"), .unknown)
    }
}
