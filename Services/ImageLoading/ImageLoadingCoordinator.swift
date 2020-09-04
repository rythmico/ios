import Foundation
import class UIKit.UIImage
import protocol Combine.Cancellable

final class ImageLoadingCoordinator: FailableActivityCoordinator<UIImage> {
    private let service: ImageLoadingServiceProtocol
    private var cancellable: Cancellable?

    init(service: ImageLoadingServiceProtocol) {
        self.service = service
    }

    func run(with source: ImageSource) {
        state = .loading
        switch source {
        case .url(let url):
            cancellable = service.load(url) { result in
                self.state = .finished(result.map { $0.withRenderingMode(.alwaysOriginal) })
            }
        case .assetName(let assetName):
            self.state = .finished(.success(UIImage(named: assetName)!))
        case .image(let image):
            self.state = .finished(.success(image))
        }
    }

    override func cancel() {
        cancellable?.cancel()
        super.cancel()
    }
}
