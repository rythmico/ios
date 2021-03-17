import UIKit
import FoundationSugar

protocol ImageProcessingServiceProtocol {
    typealias CompletionHandler = Handler<UIImage>

    func process(_ image: UIImage, handler: @escaping CompletionHandler)
}

final class ImageProcessingService: ImageProcessingServiceProtocol {
    func process(_ image: UIImage, handler: @escaping CompletionHandler) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let cgImage = image.cgImage {
                UIGraphicsBeginImageContext(image.size)
                UIGraphicsGetCurrentContext()?.draw(cgImage, in: CGRect(origin: .zero, size: image.size))
                UIGraphicsEndImageContext()
            }

            DispatchQueue.main.async {
                handler(image)
            }
        }
    }
}
