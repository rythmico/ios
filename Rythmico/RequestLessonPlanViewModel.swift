import Foundation
@testable import ViewModel

final class RequestLessonPlanViewModel: ViewModelObject<RequestLessonPlanViewData> {
    init() {
        super.init(viewData: .init())
        let viewModel = InstrumentSelectionViewModel(instrumentProvider: InstrumentProviderFake())
        self.viewData.instrumentSelectionView = InstrumentSelectionView(viewModel: viewModel)
    }
}
