import CoreDTO
import SwiftUIEncore

extension AppEnvironment {
    enum AppStoreScreenshotNumbers {
        case twoThreeAndFour
        case five
    }

    static func appStoreScreenshots(_ screenshotNumbers: AppStoreScreenshotNumbers) -> AppEnvironment {
        dummy => {
            $0.setUpFake()

            $0.imageLoadingCoordinator = {
                ImageLoadingCoordinator(
                    loadingService: ImageLoadingService(),
                    processingService: ImageProcessingServiceStub()
                )
            }

            $0.stubAPIEndpoint(for: \.availableInstrumentsFetchingCoordinator, result: .success(.stub))
            $0.stubLessonPlans(for: screenshotNumbers)
        }
    }

    private mutating func stubLessonPlans(for screenshotNumbers: AppStoreScreenshotNumbers) {
        let lessonPlans: [LessonPlan]
        switch screenshotNumbers {
        case .twoThreeAndFour:
            lessonPlans = [
                .screenshotJackDrumsPlanStub,
                .screenshotJackGuitarPlanStub,
                .screenshotCharlottePianoPlanStub,
            ]
        case .five:
            lessonPlans = [
                .screenshotJackGuitarPlanStub,
                .screenshotCharlottePianoPlanStub => {
                    $0.status = .screenshotCharlottePianoPlanPaused
                    $0.options = .pausedStub
                },
                .screenshotJackDrumsPlanStub => (\.status, .screenshotJackDrumsPlanCancelled),
            ]
        }
        stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success(lessonPlans))
    }
}
