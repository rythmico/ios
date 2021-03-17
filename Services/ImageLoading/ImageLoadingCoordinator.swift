import Foundation
import class UIKit.UIImage

final class ImageLoadingCoordinator: FailableActivityCoordinator<ImageReference, UIImage> {
    private let service: ImageLoadingServiceProtocol

    init(service: ImageLoadingServiceProtocol) {
        self.service = service
    }

    override func performTask(with input: ImageReference) {
        super.performTask(with: input)
        switch input {
        case .url(let url):
            activity = service.load(url, handler: finish)
        case .assetName(let assetName):
            finish(.success(UIImage(named: assetName)!))
        case .image(let image):
            finish(.success(image))
        }
    }
}
