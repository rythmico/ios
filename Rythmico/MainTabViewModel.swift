import Foundation
@testable import ViewModel

final class MainTabViewModel: ViewModelObject<MainTabViewData> {
    private let accessTokenProvider: AuthenticationAccessTokenProvider

    init(accessTokenProvider: AuthenticationAccessTokenProvider) {
        self.accessTokenProvider = accessTokenProvider
        super.init(viewData: .init())
    }

    func presentRequestLessonFlow() {
        viewData.lessonRequestView = LessonRequestView()
    }

    func dismissRequestLessonFlow() {
        viewData.lessonRequestView = nil
    }
}
