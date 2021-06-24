import FoundationSugar
import class UIKit.UIImage

final class ImageProcessingServiceStub: ImageProcessingServiceProtocol {
    var delay: TimeInterval?

    init(delay: TimeInterval? = nil) {
        self.delay = delay
    }

    func process(_ image: UIImage, handler: @escaping CompletionHandler) {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                handler(image)
            }
        } else {
            handler(image)
        }
    }
}

final class ImageProcessingServiceSpy: ImageProcessingServiceProtocol {
    private(set) var processCount = 0
    private(set) var latestImage: UIImage?

    func process(_ image: UIImage, handler: @escaping CompletionHandler) {
        processCount += 1
        latestImage = image
    }
}

final class ImageProcessingServiceDummy: ImageProcessingServiceProtocol {
    func process(_ image: UIImage, handler: @escaping CompletionHandler) {}
}
