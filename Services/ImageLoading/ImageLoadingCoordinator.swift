import Foundation
import class UIKit.UIImage
import protocol Combine.Cancellable

final class ImageLoadingCoordinator: FailableActivityCoordinator<UIImage> {
    private let service: ImageLoadingServiceProtocol
    private var activity: Activity?

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
            activity = service.load(url) { result in
                self.state = .finished(result)
            }
        case .assetName(let assetName):
            self.state = .finished(.success(UIImage(named: assetName)!))
        case .image(let image):
            self.state = .finished(.success(image))
        }
    }

    override func resume() {
        super.resume()
        if case .suspended = state {
            activity?.resume()
        }
    }

    override func suspend() {
        super.suspend()
        if case .loading = state {
            activity?.suspend()
        }
    }

    override func cancel() {
        super.cancel()
        if case .loading = state {
            activity?.cancel()
        }
    }
}
