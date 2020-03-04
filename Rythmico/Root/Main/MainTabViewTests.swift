import XCTest
@testable import Rythmico

final class MainTabViewTests: XCTestCase {
    func testPresentRequestLessonFlow() {
        let view = MainTabView(accessTokenProvider: AuthenticationAccessTokenProviderDummy())

        XCTAssertView(view) { view in
            XCTAssertNil(view.lessonRequestView)
            view.presentRequestLessonFlow()
            XCTAssertNotNil(view.lessonRequestView)
        }
    }
}
