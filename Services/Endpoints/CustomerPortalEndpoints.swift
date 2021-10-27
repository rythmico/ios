import APIKit

struct GetCustomerPortalURLRequest: APIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/customer-portal-url"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = StripeCustomerPortal
}
