import Foundation
import ViewModel

final class RequestLessonPlanViewModel: ViewModelObject<RequestLessonPlanViewData> {
    init(instrumentProvider: InstrumentProviderProtocol) {
        let viewModel = InstrumentSelectionViewModel(instrumentProvider: instrumentProvider)
        super.init(viewData: .init(currentStep: .instrumentSelection(InstrumentSelectionView(viewModel: viewModel))))
    }
}
