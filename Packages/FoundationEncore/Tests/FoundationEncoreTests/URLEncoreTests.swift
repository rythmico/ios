import XCTest
import FoundationEncore

final class URLEncoreTests: XCTestCase {
    func testInitWithSchemeAndHost() {
        XCTAssertEqual(try URL(scheme: "https", host: ""), "https://")
        XCTAssertEqual(try URL(scheme: "https", host: "rythmico.com"), "https://rythmico.com")
    }

    func testFullInit() {
        XCTAssertEqual(
            try URL(scheme: "mailto", doubleSlash: false, host: "foobar", path: "", queryItems: nil),
            "mailto:foobar"
        )
        XCTAssertEqual(
            try URL(scheme: "https", doubleSlash: true, host: "rythmico.com", path: "", queryItems: nil),
            "https://rythmico.com"
        )
        XCTAssertEqual(
            try URL(scheme: "https", doubleSlash: true, host: "rythmico.com", path: "/", queryItems: nil),
            "https://rythmico.com/"
        )
        XCTAssertEqual(
            try URL(scheme: "https", doubleSlash: true, host: "rythmico.com", path: "/", queryItems: []),
            "https://rythmico.com/?"
        )
        XCTAssertEqual(
            try URL(scheme: "https", doubleSlash: true, host: "rythmico.com", path: "/", queryItems: [
                URLQueryItem(name: "", value: "")
            ]),
            "https://rythmico.com/?="
        )
        XCTAssertEqual(
            try URL(scheme: "https", doubleSlash: true, host: "rythmico.com", path: "/", queryItems: [
                URLQueryItem(name: "foo", value: "bar")
            ]),
            "https://rythmico.com/?foo=bar"
        )
        XCTAssertThrowsError(
            try URL(scheme: "https", doubleSlash: true, host: "rythmico.com", path: "foo", queryItems: [
                URLQueryItem(name: "foo", value: "bar")
            ])
        ) { error in
            let urlComponents = URLComponents() => {
                $0.scheme = "https"
                $0.host = "rythmico.com"
                $0.path = "foo"
                $0.queryItems = [URLQueryItem(name: "foo", value: "bar")]
            }
            switch error {
            case URL.Error.invalidURLComponents(urlComponents): break
            default: XCTFail("Unexpected error received: \(error)")
            }
        }
    }
}
