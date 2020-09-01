import Foundation
import struct SwiftUI.Image
import class UIKit.UIImage
import Sugar

protocol ImageLoadingServiceProtocol {
    typealias DataCompletionHandler = SimpleResultHandler<Data>
    typealias ImageCompletionHandler = SimpleResultHandler<Image>

    func load(_ url: URL, completion: @escaping DataCompletionHandler) -> URLSessionTask
    func load(_ url: URL, completion: @escaping ImageCompletionHandler) -> URLSessionTask
}

final class ImageLoadingService: ImageLoadingServiceProtocol {
    enum Error: Swift.Error {
        case invalidResponse
    }

    private let sessionConfiguration = URLSessionConfiguration.ephemeral.then {
        $0.waitsForConnectivity = true
        $0.timeoutIntervalForResource = 150
        $0.requestCachePolicy = .reloadRevalidatingCacheData
    }

    func load(_ url: URL, completion: @escaping DataCompletionHandler) -> URLSessionTask {
        load(url, on: .main, completion: completion)
    }

    func load(_ url: URL, completion: @escaping ImageCompletionHandler) -> URLSessionTask {
        load(url, on: .current) { dataResult in
            let imageResult = dataResult.flatMap {
                UIImage(data: $0).map(Image.init).map(Result.success)
                ??
                .failure(Error.invalidResponse)
            }
            RunLoop.main.perform {
                completion(imageResult)
            }
        }
    }

    private func load(_ url: URL, on runLoop: RunLoop, completion: @escaping DataCompletionHandler) -> URLSessionTask {
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
        }
    }
}
