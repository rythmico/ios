import SwiftUI
import Sugar

protocol InstrumentSelectionContext {
    func setInstrument(_ instrument: Instrument)
}

struct InstrumentSelectionView: View, TestableView {
    private let context: InstrumentSelectionContext
    private let instrumentProvider: InstrumentSelectionListProviderProtocol

    @State var instruments: [InstrumentViewData] = []

    init(
        context: InstrumentSelectionContext,
        instrumentProvider: InstrumentSelectionListProviderProtocol
    ) {
        self.context = context
        self.instrumentProvider = instrumentProvider
    }

    var didAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Choose Instrument", subtitle: "Select one instrument") {
            CollectionView(instruments, id: \.name) {
                InstrumentView(viewData: $0).padding(.horizontal, .spacingMedium)
            }
            .padding(.horizontal, -.spacingMedium)
        }
        .onAppear { self.didAppear?(self) }
        .onAppear(perform: onAppear)
    }

    private func onAppear() {
        instrumentProvider.instruments { instruments in
            withAnimation(.none) {
                self.instruments = instruments
                    .map { instrument in
                        InstrumentViewData(name: instrument.name, icon: instrument.icon, action: {
                            self.context.setInstrument(instrument)
                        })
                    }
            }
        }
    }
}
