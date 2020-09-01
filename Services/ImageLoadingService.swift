import Foundation
import struct SwiftUI.Image
import class UIKit.UIImage
import protocol Combine.Cancellable
import Sugar

protocol ImageLoadingServiceProtocol {
    typealias CompletionHandler = SimpleResultHandler<Image>

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable
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

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable {
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
