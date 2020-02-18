import Foundation
@testable import ViewModel

final class RequestLessonPlanViewModel: ViewModelObject<RequestLessonPlanViewData> {
    init(instrumentProvider: InstrumentProviderProtocol) {
        super.init(viewData: .init())
        let viewModel = InstrumentSelectionViewModel(instrumentProvider: instrumentProvider)
        self.viewData.instrumentSelectionView = InstrumentSelectionView(viewModel: viewModel)
    }
}
