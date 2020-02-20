import Foundation
import ViewModel

final class StudentDetailsViewModel: ViewModelObject<StudentDetailsViewData> {
    private let context: RequestLessonPlanContextProtocol

    init(
        context: RequestLessonPlanContextProtocol,
        instrument: Instrument
    ) {
        self.context = context
        super.init(viewData: .init(selectedInstrumentName: instrument.name))
    }
}
