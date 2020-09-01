import Foundation
import struct SwiftUI.Image
import protocol Combine.Cancellable

final class ImageLoadingServiceStub: ImageLoadingServiceProtocol {
    var result: Result<Image, Error>
    var delay: TimeInterval?

    init(result: Result<Image, Error>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(self.result)
            }
        } else {
            completion(result)
        }
        return CancellableDummy()
    }
}

final class ImageLoadingServiceSpy: ImageLoadingServiceProtocol {
    private(set) var loadCount = 0
    private(set) var latestURL: URL?
    private(set) var cancellable: CancellableSpy?

    var result: Result<Image, Error>?

    init(result: Result<Image, Error>? = nil) {
        self.result = result
    }

    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable {
        loadCount += 1
        latestURL = url
        result.map(completion)
        return CancellableSpy()
    }
}

final class ImageLoadingServiceDummy: ImageLoadingServiceProtocol {
    func load(_ url: URL, completion: @escaping CompletionHandler) -> Cancellable {
        CancellableDummy()
    }
}
