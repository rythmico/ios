import FoundationEncore
import class UIKit.UIImage

final class ImageLoadingCoordinator: FailableActivityCoordinator<ImageReference, UIImage> {
    private let loadingService: ImageLoadingServiceProtocol
    private let processingService: ImageProcessingServiceProtocol

    init(
        loadingService: ImageLoadingServiceProtocol,
        processingService: ImageProcessingServiceProtocol
    ) {
        self.loadingService = loadingService
        self.processingService = processingService
    }

    override func performTask(with input: ImageReference) {
        super.performTask(with: input)
        switch input {
        case .url(let url):
            activity = loadingService.load(url, handler: finish)
        case .assetName(let assetName):
            finish(.success(UIImage(named: assetName)!))
        case .image(let image):
            finish(.success(image))
        }
    }

    override func finish(_ output: Result<UIImage, Error>) {
        switch output {
        case .success(let unprocessedImage):
            processingService.process(unprocessedImage) { image in
                super.finish(.success(image))
            }
        case .failure:
            super.finish(output)
        }
    }
}
