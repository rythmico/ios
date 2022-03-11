import FoundationEncore
import StoreKit

struct AppStoreReviewPrompt {
    let requestReview: Action
}

extension AppStoreReviewPrompt {
    static let live = Self(
        requestReview: {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    )
}
