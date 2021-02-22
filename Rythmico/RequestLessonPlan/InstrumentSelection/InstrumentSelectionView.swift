import SwiftUI
import FoundationSugar

protocol InstrumentSelectionContext {
    func setInstrument(_ instrument: Instrument)
}

struct InstrumentSelectionView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var instruments: [InstrumentViewData] = []
    }

    @ObservedObject var state: ViewState
    private let context: InstrumentSelectionContext

    init(state: ViewState, context: InstrumentSelectionContext) {
        self.state = state
        self.context = context
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(title: "Choose Instrument", subtitle: "Select one instrument") {
            CollectionView(state.instruments, id: \.name) {
                InstrumentView(viewData: $0)
            }
        }
        .testable(self)
        .onAppear(perform: fetchInstruments)
    }

    private func fetchInstruments() {
        Current.instrumentSelectionListProvider.instruments { instruments in
            state.instruments = instruments
                .map { instrument in
                    InstrumentViewData(
                        name: instrument.standaloneName,
                        icon: instrument.icon,
                        action: { context.setInstrument(instrument) }
                    )
                }
        }
    }
}
