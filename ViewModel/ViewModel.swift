import Foundation
import Combine

public protocol ViewModel: ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher {
    associatedtype ViewData
    var viewData: ViewData { get }
}

/// A value whose existence is promised at a later time in the initialization process.
/// Useful for scenarios where `self` is needed before all other properties have been initialized.
/// Preferred to IUOs (!) due to the explicitness of intent.
@propertyWrapper
public enum Delayed<T> {
    case existing(T)
    case delayed

    public var wrappedValue: T {
        get {
            switch self {
            case .existing(let value):
                return value
            case .delayed:
                preconditionFailure("Value of type \(T.self) needs to be set before it can be accessed")
            }
        }
        set {
            self = .existing(newValue)
        }
    }
}

// Temporary solution since `Published` doesn't support specifying a dispatch queue,
// nor do property wrappers allow chaining in order to do something like
// `@Published @ExecuteOn(.main)`.
open class ViewModelObject<ViewData>: ViewModel {
    public let objectWillChange = ObservableObjectPublisher()

    // protected(set) is direly needed here *sigh*
    @Delayed public var viewData: ViewData {
        willSet { DispatchQueue.main.async(execute: objectWillChange.send) }
    }

    public init(viewData: ViewData) {
        self._viewData = .existing(viewData)
    }

    /// Using this initializer requires that `viewData` be set before initialization is finished.
    public init() {
        self._viewData = .delayed
    }
}
