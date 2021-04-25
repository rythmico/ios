import UIKit
import FoundationSugar

protocol ImageProcessingServiceProtocol {
    typealias CompletionHandler = Handler<UIImage>

    func process(_ image: UIImage, handler: @escaping CompletionHandler)
}

final class ImageProcessingService: ImageProcessingServiceProtocol {
    private let queue = DispatchQueue(label: "com.rythmico.ImageProcessingService", qos: .userInitiated, attributes: .concurrent)

    func process(_ image: UIImage, handler: @escaping CompletionHandler) {
        queue.async {
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
