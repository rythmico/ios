import Foundation
import class UIKit.UIImage
import protocol Combine.Cancellable

final class ImageLoadingCoordinator: FailableActivityCoordinator<UIImage> {
    private let service: ImageLoadingServiceProtocol
    private var cancellable: Cancellable?

    init(service: ImageLoadingServiceProtocol) {
        self.service = service
    }

    func start(with imageReference: ImageReference) {
        if case .loading = state {
            return
        }
        state = .loading
        switch imageReference {
        case .url(let url):
            cancellable = service.load(url) { result in
                self.state = .finished(result)
            }
        case .assetName(let assetName):
            self.state = .finished(.success(UIImage(named: assetName)!))
        case .image(let image):
            self.state = .finished(.success(image))
        }
    }

    override func cancel() {
        if case .loading = state {
            cancellable?.cancel()
        }
        super.cancel()
    }
}
