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
        load(url, on: .current) { dataResult in
            let imageResult = dataResult.flatMap {
                UIImage(data: $0).map(Result.success)
                ??
                .failure(Error.invalidResponse)
            }
            DispatchQueue.main.immediateOrAsync {
                completion(imageResult)
            }
        }
    }

    private typealias DataCompletionHandler = SimpleResultHandler<Data>

    private func load(_ url: URL, on runLoop: RunLoop, completion: @escaping DataCompletionHandler) -> Cancellable {
        URLSession(configuration: sessionConfiguration).dataTask(with: url) { data, _, error in
            runLoop.perform {
                switch (error, data) {
                case (let error?, _):
                    completion(.failure(error))
                case (_, let data?):
                    completion(.success(data))
                case (nil, nil):
                    fatalError("Impossible")
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
