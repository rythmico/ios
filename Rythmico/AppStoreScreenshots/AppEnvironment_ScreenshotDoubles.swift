import SwiftUIEncore

extension AppEnvironment {
    enum AppStoreScreenshotNumbers {
        case twoThreeAndFour
        case five
    }

    static func appStoreScreenshots(_ screenshotNumbers: AppStoreScreenshotNumbers) -> AppEnvironment {
        dummy.with {
            $0.setUpFake()

            $0.imageLoadingCoordinator = {
                ImageLoadingCoordinator(
                    loadingService: ImageLoadingService(),
                    processingService: ImageProcessingServiceStub()
                )
            }

            $0.instrumentSelectionListProvider = InstrumentSelectionListProviderStub(instruments: Instrument.allCases)
            $0.fakeLessonPlans(for: screenshotNumbers)
        }
    }

    private mutating func fakeLessonPlans(for screenshotNumbers: AppStoreScreenshotNumbers) {
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
                .screenshotCharlottePianoPlanStub.with {
                    $0.status = .screenshotCharlottePianoPlanPaused
                    $0.options = .pausedStub
                },
                .screenshotJackDrumsPlanStub.with(\.status, .screenshotJackDrumsPlanCancelled),
            ]
        }
        fakeAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success(lessonPlans), delay: nil)
    }
}
