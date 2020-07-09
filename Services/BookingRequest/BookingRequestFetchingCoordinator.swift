import Foundation
import Combine

final class BookingRequestFetchingCoordinator: ObservableObject {
    enum State {
        case idle
        case loading
        case failure(Error)
        case success([BookingRequest])
    }

    @Published
    private(set) var state: State = .idle

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let service: BookingRequestFetchingServiceProtocol
    private let repository: BookingRequestRepository

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        service: BookingRequestFetchingServiceProtocol,
        repository: BookingRequestRepository
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.service = service
        self.repository = repository
    }

    func fetchBookingRequests() {
        state = .loading
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                self.service.bookingRequests(accessToken: accessToken) { result in
                    switch result {
                    case .success(let bookingRequests):
                        self.state = .success(bookingRequests)
                        self.repository.latestBookingRequests = bookingRequests
                    case .failure(let error):
                        self.state = .failure(error)
                    }
                }
            case .failure(let error):
                self.state = .failure(error) // TODO: handle
            }
        }
    }

    func dismissFailure() {
        if case .failure = state {
            state = .idle
        }
    }
}
