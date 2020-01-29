import Foundation
import Auth

final class MainTabViewModel {
    private let accessTokenProvider: AuthenticationAccessTokenProvider

    init(accessTokenProvider: AuthenticationAccessTokenProvider) {
        self.accessTokenProvider = accessTokenProvider
    }
}
