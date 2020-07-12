import Foundation

final class BookingRequestFetchingCoordinator: FailableActivityCoordinator<[BookingRequest]> {
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
                        self.state = .finished(.success(bookingRequests))
                        self.repository.latestBookingRequests = bookingRequests
                    case .failure(let error):
                        self.state = .finished(.failure(error))
                    }
                }
            case .failure(let error):
                self.state = .finished(.failure(error)) // TODO: handle
            }
        }
    }
}
