import APIKit

struct GetCustomerPortalURLRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/customer-portal-url"

    typealias Response = StripeCustomerPortal
    typealias Error = RythmicoAPIError
}
