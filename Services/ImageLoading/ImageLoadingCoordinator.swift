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
            activity = service.load(url) { result in
                self.finish(result)
            }
        case .assetName(let assetName):
            self.finish(.success(UIImage(named: assetName)!))
        case .image(let image):
            self.finish(.success(image))
        }
    }
}
