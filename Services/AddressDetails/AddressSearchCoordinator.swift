import Foundation

final class AddressSearchCoordinator: ObservableObject {
    enum State {
        case idle
        case loading
        case failure(Error)
        case success([AddressDetails])
    }

    @Published
    var state: State = .idle

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let service: AddressSearchServiceProtocol

    init(accessTokenProvider: AuthenticationAccessTokenProvider, service: AddressSearchServiceProtocol) {
        self.accessTokenProvider = accessTokenProvider
        self.service = service
    }

    func searchAddresses(withPostcode postcode: String) {
        state = .loading
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                self.service.addresses(accessToken: accessToken, postcode: postcode) { result in
                    switch result {
                    case .success(let addressDetails):
                        self.state = .success(addressDetails)
                    case .failure(let error):
                        self.state = .failure(error)
                    }
                }
            case .failure(let error):
                self.state = .failure(error)
            }
        }
    }

    func dismissError() {
        if state.isFailure {
            state = .idle
        }
    }
}
