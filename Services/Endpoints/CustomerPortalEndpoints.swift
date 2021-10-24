import APIKit

struct GetCustomerPortalURLRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/customer-portal-url"
    var headerFields: [String: String] = [:]

    typealias Response = StripeCustomerPortal
}
