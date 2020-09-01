import Foundation
import struct SwiftUI.Image
import protocol Combine.Cancellable

final class ImageLoadingCoordinator: FailableActivityCoordinator<Image> {
    private let service: ImageLoadingServiceProtocol
    private var cancellable: Cancellable?

    init(service: ImageLoadingServiceProtocol) {
        self.service = service
    }

    func run(with url: URL) {
        state = .loading
        cancellable = service.load(url) { result in
            self.state = .finished(result)
        }
    }

    override func cancel() {
        cancellable?.cancel()
        super.cancel()
    }
}
