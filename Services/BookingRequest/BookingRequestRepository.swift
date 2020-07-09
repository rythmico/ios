import Foundation
import Combine

final class BookingRequestRepository: ObservableObject {
    @Published var latestBookingRequests: [BookingRequest] = []
}
