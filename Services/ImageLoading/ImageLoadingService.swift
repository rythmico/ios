import Foundation
import class UIKit.UIImage
import FoundationSugar

protocol ImageLoadingServiceProtocol {
    typealias CompletionHandler = SimpleResultHandler<UIImage>

    func load(_ url: URL, handler: @escaping CompletionHandler) -> Activity
}

final class ImageLoadingService: ImageLoadingServiceProtocol {
    enum Error: Swift.Error {
        case imageDecodingFailed
    }

    private let sessionConfiguration = URLSessionConfiguration.default.then {
        $0.waitsForConnectivity = true
        $0.timeoutIntervalForResource = 150
        $0.requestCachePolicy = .returnCacheDataElseLoad
        $0.urlCache = URLCache.imageURLCache
    }

    func load(_ url: URL, handler: @escaping CompletionHandler) -> Activity {
        URLSession(configuration: sessionConfiguration).dataTask(with: url) { data, _, error in
            guard let dataResult = Result(value: data, error: error) else {
                assertionFailure("Impossible code path for ImageLoadingService")
                return
            }
            let imageResult: Result<UIImage, Swift.Error> = dataResult.flatMap {
                if let image = UIImage(data: $0) {
                    return .success(image.withRenderingMode(.alwaysOriginal))
                } else {
                    return .failure(Error.imageDecodingFailed)
                }
            }
            DispatchQueue.main.nowOrAsync {
                handler(imageResult)
            }
        }.then { $0.resume() }
    }
}

private extension URLCache {
    static let inMemorySizeMegabytes = 75
    static let inDiskSizeMegabytes = 100

    static let imageURLCache = URLCache(
        memoryCapacity: inMemorySizeMegabytes * 1024 * 1024,
        diskCapacity: inDiskSizeMegabytes * 1024 * 1024,
        diskPath: nil
    )
}
