#if DEBUG
import Foundation
import class UIKit.UIImage
import protocol Combine.Cancellable

final class ImageLoadingServiceStub: ImageLoadingServiceProtocol {
    private var cache: [URL: UIImage] = [:]

    var result: Result<UIImage, Error>
    var delay: TimeInterval?

    init(result: Result<UIImage, Error>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable {
        if let image = cache[url] {
            completion(.success(image))
        } else {
            if let image = try? result.get() {
                cache[url] = image
            }
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    completion(self.result)
                }
            } else {
                completion(result)
            }
        }
        return CancellableDummy()
    }
}

final class ImageLoadingServiceSpy: ImageLoadingServiceProtocol {
    private var cache: [URL: UIImage] = [:]

    private(set) var loadCount = 0
    private(set) var latestURL: URL?
    private(set) var cancellable: CancellableSpy?

    var result: Result<UIImage, Error>?

    init(result: Result<UIImage, Error>? = nil) {
        self.result = result
    }

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable {
        if let image = cache[url] {
            completion(.success(image))
        } else {
            if let image = try? result?.get() {
                cache[url] = image
            }
            loadCount += 1
            latestURL = url
            result.map(completion)
        }
        return CancellableSpy()
    }
}

final class ImageLoadingServiceDummy: ImageLoadingServiceProtocol {
    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable {
        CancellableDummy()
    }
}
#endif
