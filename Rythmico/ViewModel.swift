import Foundation
import Combine

protocol ViewModel: ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher {
    associatedtype ViewData
    var viewData: ViewData { get }
}

protocol ViewModelable {
    associatedtype ViewModel: Rythmico.ViewModel
    var viewModel: ViewModel { get }
}

extension ViewModelable {
    var viewData: ViewModel.ViewData { viewModel.viewData }
}
