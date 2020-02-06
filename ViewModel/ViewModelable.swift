// Workaround because disambiguation of types with the
// same module name is not possible at the moment.
public typealias _ViewModel = ViewModel

public protocol ViewModelable {
    associatedtype ViewModel: _ViewModel
    var viewModel: ViewModel { get }
}

extension ViewModelable {
    public var viewData: ViewModel.ViewData { viewModel.viewData }
}
