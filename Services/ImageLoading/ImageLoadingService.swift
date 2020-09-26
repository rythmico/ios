import Foundation
import class UIKit.UIImage
import protocol Combine.Cancellable
import Sugar

protocol ImageLoadingServiceProtocol {
    typealias CompletionHandler = SimpleResultHandler<UIImage>

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Activity
}

final class ImageLoadingService: ImageLoadingServiceProtocol {
    enum Error: Swift.Error {
        case invalidResponse
    }

    private let sessionConfiguration = URLSessionConfiguration.default.then {
        $0.waitsForConnectivity = true
        $0.timeoutIntervalForResource = 150
        $0.requestCachePolicy = .returnCacheDataElseLoad
        $0.urlCache = URLCache.imageURLCache
    }

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Activity {
        URLSession(configuration: sessionConfiguration).dataTask(with: url) { data, _, error in
            DispatchQueue.global().async {
                let result: Result<UIImage, Swift.Error>
                switch (error, data) {
                case (let error?, _):
                    result = .failure(error)
                case (_, let data?):
                    result = UIImage(data: data).map { .success($0.withRenderingMode(.alwaysOriginal)) } ?? .failure(Error.invalidResponse)
                case (nil, nil):
                    fatalError("Impossible")
                }
                DispatchQueue.main.async {
                    completion(result)
                }
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
