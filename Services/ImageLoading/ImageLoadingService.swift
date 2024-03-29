import FoundationEncore
import class UIKit.UIImage

protocol ImageLoadingServiceProtocol {
    typealias CompletionHandler = ResultHandler<UIImage, Error>

    func load(_ url: URL, handler: @escaping CompletionHandler) -> Activity
}

final class ImageLoadingService: ImageLoadingServiceProtocol {
    enum Error: Swift.Error {
        case imageDecodingFailed
    }

    private let sessionConfiguration = URLSessionConfiguration.default => {
        $0.waitsForConnectivity = true
        $0.timeoutIntervalForResource = 150
        $0.requestCachePolicy = .returnCacheDataElseLoad
        $0.urlCache = URLCache.imageURLCache
    }

    func load(_ url: URL, handler: @escaping CompletionHandler) -> Activity {
        URLSession(configuration: sessionConfiguration).dataTask(with: url) { data, response, error in
            let dataResult = Result(value: data, error: error) !! preconditionFailure("Impossible code path for ImageLoadingService")
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
        } => { $0.resume() }
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
