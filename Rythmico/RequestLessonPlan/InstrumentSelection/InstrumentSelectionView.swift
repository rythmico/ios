import SwiftUI
import Sugar

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

    var onAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Choose Instrument", subtitle: "Select one instrument") {
            CollectionView(
                state.instruments,
                id: \.name,
                padding: .init(top: 7, bottom: .spacingMedium)
            ) {
                InstrumentView(viewData: $0).padding(.horizontal, .spacingMedium)
            }
        }
        .onAppear { self.onAppear?(self) }
        .onAppear(perform: fetchInstruments)
    }

    private func fetchInstruments() {
        Current.instrumentSelectionListProvider.instruments { instruments in
            self.state.instruments = instruments
                .map { instrument in
                    InstrumentViewData(
                        name: instrument.name,
                        icon: instrument.icon,
                        action: { self.context.setInstrument(instrument) }
                    )
                }
        }
    }
}
