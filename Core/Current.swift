import FoundationEncore

private extension AppContext {
    var environment: AppEnvironment {
        #if DEBUG
        switch self {
        case .test:
            return .dummy
        case .preview:
            return .fake
        case .run:
//            return .appStoreScreenshots(.twoThreeAndFour)
//            return .appStoreScreenshots(.five)
//            return .fake
            return .live => {
                #if RYTHMICO
                $0.appStoreReviewPrompt = .dummy
                #elseif TUTOR
                _ = $0
                #endif
            }
        case .release:
            return .live
        }
        #else
        return .live
        #endif
    }
}

#if DEBUG
var Current: AppEnvironment = AppContext.current.environment
#else
let Current: AppEnvironment = AppContext.current.environment
#endif
