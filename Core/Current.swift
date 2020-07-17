private extension AppContext {
    var environment: AppEnvironment {
        switch self {
        case .test:
            return .dummy
        case .preview:
            return .fake
        case .debug:
            return .fake
//            return .live
        case .release:
            return .live
        }
    }
}

#if DEBUG
var Current: AppEnvironment = AppContext.current.environment
#else
let Current: AppEnvironment = AppContext.current.environment
#endif
