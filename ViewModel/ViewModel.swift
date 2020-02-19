import Foundation
import Combine

public protocol ViewModel: ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher {
    associatedtype ViewData
    var viewData: ViewData { get }
}

// Temporary solution since `Published` doesn't support specifying a dispatch queue,
// nor do property wrappers allow chaining in order to do something like
// `@Published @ExecuteOn(.main)`.
open class ViewModelObject<ViewData>: ViewModel {
    public let objectWillChange = ObservableObjectPublisher()

    // protected(set) is direly needed here *sigh*
    public var viewData: ViewData {
        willSet { DispatchQueue.main.async(execute: objectWillChange.send) }
    }

    public init(viewData: ViewData) {
        self.viewData = viewData
    }
}
