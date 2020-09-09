private extension AppContext {
    var environment: AppEnvironment {
        #if DEBUG
        switch self {
        case .test:
            return .dummy
        case .preview:
            return .fake
        case .run:
//            return .fake
            return .live
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
