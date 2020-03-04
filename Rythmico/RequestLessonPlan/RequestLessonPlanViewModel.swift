import Foundation
import SwiftUI
import ViewModel

final class RequestLessonPlanViewModel: ViewModelObject<RequestLessonPlanViewData> {
    typealias Step = RequestLessonPlanViewData.Step

    private let context: RequestLessonPlanContextProtocol
    private let instrumentProvider: InstrumentSelectionListProviderProtocol

    init(instrumentProvider: InstrumentSelectionListProviderProtocol) {
        self.instrumentProvider = instrumentProvider
        let context = RequestLessonPlanContext()
        self.context = context
        super.init(viewData: .init(currentStep: .instrumentSelection(InstrumentSelectionView(context: context, instrumentProvider: instrumentProvider))))
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

    private func step(for context: RequestLessonPlanContextProtocol) -> Step {
        [
            AddressDetailsView(context: context).map(Step.addressDetails),
            StudentDetailsView(context: context, editingCoordinator: UIApplication.shared, dispatchQueue: .main).map(Step.studentDetails)
        ]
        .lazy.compactMap { $0 }.first ?? .instrumentSelection(InstrumentSelectionView(context: context, instrumentProvider: instrumentProvider))
    }
}
