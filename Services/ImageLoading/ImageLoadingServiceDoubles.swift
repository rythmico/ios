import FoundationEncore
import class UIKit.UIImage

final class ImageLoadingServiceStub: ImageLoadingServiceProtocol {
    private var cache: [URL: UIImage] = [:]

    var result: Result<UIImage, Error>
    var delay: TimeInterval?

    init(result: Result<UIImage, Error>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func load(_ url: URL, handler: @escaping CompletionHandler) -> Activity {
        if let image = cache[url] {
            handler(.success(image))
        } else {
            if let image = try? result.get() {
                cache[url] = image
            }
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
                    handler(result)
                }
            } else {
                handler(result)
            }
        }
        return ActivityDummy()
    }
}

final class ImageLoadingServiceSpy: ImageLoadingServiceProtocol {
    private var cache: [URL: UIImage] = [:]

    private(set) var loadCount = 0
    private(set) var latestURL: URL?
    private(set) var activity: ActivitySpy?

    var result: Result<UIImage, Error>?

    init(result: Result<UIImage, Error>? = nil) {
        self.result = result
    }

    func load(_ url: URL, handler: @escaping CompletionHandler) -> Activity {
        if let image = cache[url] {
            handler(.success(image))
        } else {
            if let image = try? result?.get() {
                cache[url] = image
            }
            loadCount += 1
            latestURL = url
            result.map(handler)
        }
        let activity = ActivitySpy()
        self.activity = activity
        return activity
    }
}

final class ImageLoadingServiceDummy: ImageLoadingServiceProtocol {
    func load(_ url: URL, handler: @escaping CompletionHandler) -> Activity {
        ActivityDummy()
    }
}
