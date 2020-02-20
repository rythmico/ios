import Foundation
import ViewModel

final class InstrumentSelectionViewModel: ViewModelObject<InstrumentSelectionViewData> {
    private let context: RequestLessonPlanContextProtocol
    private let instrumentProvider: InstrumentProviderProtocol

    init(
        context: RequestLessonPlanContextProtocol,
        instrumentProvider: InstrumentProviderProtocol
    ) {
        self.context = context
        self.instrumentProvider = instrumentProvider
        super.init(viewData: .init())
        instrumentProvider.instruments { instruments in
            self.viewData.instruments = instruments
                .map { instrument in
                    InstrumentViewData(name: instrument.name, icon: instrument.icon, action: {
                        context.instrument = instrument
                    })
                }
        }
    }
}
