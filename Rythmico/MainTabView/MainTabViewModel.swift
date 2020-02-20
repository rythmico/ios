import Foundation
import ViewModel

final class MainTabViewModel: ViewModelObject<MainTabViewData> {
    private let accessTokenProvider: AuthenticationAccessTokenProvider

    init(accessTokenProvider: AuthenticationAccessTokenProvider) {
        self.accessTokenProvider = accessTokenProvider
        super.init(viewData: .init())
    }

    func presentRequestLessonFlow() {
        viewData.lessonRequestView = RequestLessonPlanView(
            viewModel: RequestLessonPlanViewModel(
                instrumentProvider: InstrumentProviderFake()
            )
        )
    }

    func dismissRequestLessonFlow() {
        viewData.lessonRequestView = nil
    }
}
