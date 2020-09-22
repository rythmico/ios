import Foundation
import class UIKit.UIImage
import protocol Combine.Cancellable
import Sugar

protocol ImageLoadingServiceProtocol {
    typealias CompletionHandler = SimpleResultHandler<UIImage>

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable
}

final class ImageLoadingService: ImageLoadingServiceProtocol {
    enum Error: Swift.Error {
        case invalidResponse
    }

    private let sessionConfiguration = URLSessionConfiguration.ephemeral.then {
        $0.waitsForConnectivity = true
        $0.timeoutIntervalForResource = 150
        $0.requestCachePolicy = .returnCacheDataElseLoad
        $0.urlCache = URLCache.imageURLCache
    }

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable {
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
    static let inMemorySizeMegabytes = 30
    static let inDiskSizeMegabytes = 20

    static let imageURLCache = URLCache(
        memoryCapacity: inMemorySizeMegabytes * 1024 * 1024,
        diskCapacity: inDiskSizeMegabytes * 1024 * 1024,
        diskPath: nil
    )
}
