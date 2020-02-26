import Foundation
import SwiftUI
import ViewModel

final class RequestLessonPlanViewModel: ViewModelObject<RequestLessonPlanViewData> {
    private let context: RequestLessonPlanContextProtocol
    private let instrumentProvider: InstrumentSelectionListProviderProtocol

    init(instrumentProvider: InstrumentSelectionListProviderProtocol) {
        self.instrumentProvider = instrumentProvider
        let context = RequestLessonPlanContext()
        self.context = context
        super.init(viewData: .init(currentStep: instrumentSelectionStep(context: context, instrumentProvider: instrumentProvider)))
        context.updateHandler = contextDidUpdate
    }

    func back() {
        guard context.student == nil else {
            context.student = nil
            return
        }

        guard context.instrument == nil else {
            context.instrument = nil
            return
        }
    }

    private func contextDidUpdate(_ context: RequestLessonPlanContextProtocol) {
        let previousStepNumber = viewData.currentStepNumber
        viewData.currentStep = step(for: context)
        viewData.direction = viewData.currentStepNumber > previousStepNumber ? .next : .back
    }

    private func step(for context: RequestLessonPlanContextProtocol) -> RequestLessonPlanViewData.Step {
        guard let instrument = context.instrument else {
            return instrumentSelectionStep(context: context, instrumentProvider: instrumentProvider)
        }

        guard let student = context.student else {
            return .studentDetails(
                StudentDetailsView(viewModel: StudentDetailsViewModel(
                    context: context,
                    instrument: instrument,
                    editingCoordinator: UIApplication.shared
                ))
            )
        }

        return .addressDetails(AddressDetailsView())
    }
}

private func instrumentSelectionStep(context: RequestLessonPlanContextProtocol, instrumentProvider: InstrumentSelectionListProviderProtocol) -> RequestLessonPlanViewData.Step {
    .instrumentSelection(
        InstrumentSelectionView(
            viewModel: InstrumentSelectionViewModel(
                context: context,
                instrumentProvider: instrumentProvider
            )
        )
    )
}
