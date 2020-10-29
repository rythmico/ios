import XCTest
@testable import Rythmico
import Stripe

final class CheckoutTests: XCTestCase {
    func testCardBrandParsing() {
        XCTAssertEqual(Card.Brand("visa"), .visa)
        XCTAssertEqual(Card.Brand("Visa"), .visa)

        XCTAssertEqual(Card.Brand("amex"), .amex)
        XCTAssertEqual(Card.Brand("Amex"), .amex)

        XCTAssertEqual(Card.Brand("mastercard"), .masterCard)
        XCTAssertEqual(Card.Brand("Mastercard"), .masterCard)

        XCTAssertEqual(Card.Brand("discover"), .discover)
        XCTAssertEqual(Card.Brand("Discover"), .discover)

        XCTAssertEqual(Card.Brand("jcb"), .JCB)
        XCTAssertEqual(Card.Brand("JCB"), .JCB)

        XCTAssertEqual(Card.Brand("diners"), .dinersClub)
        XCTAssertEqual(Card.Brand("Diners"), .dinersClub)

        XCTAssertEqual(Card.Brand("unionpay"), .unionPay)
        XCTAssertEqual(Card.Brand("Unionpay"), .unionPay)

        XCTAssertEqual(Card.Brand("unknown"), .unknown)
        XCTAssertEqual(Card.Brand("Unknown"), .unknown)
        XCTAssertEqual(Card.Brand("blabla"), .unknown)
    }
}
