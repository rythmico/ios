import Foundation
import class UIKit.UIImage
import protocol Combine.Cancellable

final class ImageLoadingCoordinator: FailableActivityCoordinator<UIImage> {
    private let service: ImageLoadingServiceProtocol
    private var cancellable: Cancellable?

    init(service: ImageLoadingServiceProtocol) {
        self.service = service
    }

    func run(with url: URL) {
        state = .loading
        cancellable = service.load(url) { result in
            self.state = .finished(result.map { $0.withRenderingMode(.alwaysOriginal) })
        }
    }

    override func cancel() {
        cancellable?.cancel()
        super.cancel()
    }
}
