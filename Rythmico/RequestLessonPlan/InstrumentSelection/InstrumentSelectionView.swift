import SwiftUI
import Sugar

protocol InstrumentSelectionContext {
    func setInstrument(_ instrument: Instrument)
}

struct InstrumentSelectionView: View, TestableView {
    private let context: InstrumentSelectionContext
    private let instrumentProvider: InstrumentSelectionListProviderProtocol

    final class ViewState: ObservableObject {
        @Published var instruments: [InstrumentViewData] = []
    }

    @ObservedObject var state: ViewState

    init(
        state: ViewState,
        context: InstrumentSelectionContext,
        instrumentProvider: InstrumentSelectionListProviderProtocol
    ) {
        self.state = state
        self.context = context
        self.instrumentProvider = instrumentProvider
    }

    var didAppear: Handler<Self>?
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
        .onAppear { self.didAppear?(self) }
        .onAppear(perform: onAppear)
    }

    private func onAppear() {
        instrumentProvider.instruments { instruments in
            self.state.instruments = instruments
                .map { instrument in
                    InstrumentViewData(name: instrument.name, icon: instrument.icon, action: {
                        self.context.setInstrument(instrument)
                    })
                }
        }
    }
}
