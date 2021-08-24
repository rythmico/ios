import FoundationEncore
import StoreKit

struct AppStoreReviewPrompt {
    let requestReview: Action
}

extension AppStoreReviewPrompt {
    static let live = Self(
        requestReview: {
            if let windowScene = UIApplication.shared.windows.first?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    )
}
