import Foundation
@testable import ViewModel

final class InstrumentSelectionViewModel: ViewModelObject<InstrumentSelectionViewData> {
    private let instrumentProvider: InstrumentProviderProtocol

    init(instrumentProvider: InstrumentProviderProtocol) {
        self.instrumentProvider = instrumentProvider
        super.init(viewData: .init())
        instrumentProvider.instruments { instruments in
            self.viewData.instruments = instruments
                .lazy
                .map { ($0.name, $0.icon) }
                .map(InstrumentViewData.init(name:icon:))
        }
    }
}
