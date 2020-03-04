import SwiftUI
import Sugar

struct InstrumentSelectionView: View, TestableView {
    private let context: RequestLessonPlanContextProtocol
    private let instrumentProvider: InstrumentSelectionListProviderProtocol

    @State var instruments: [InstrumentViewData] = []

    init(
        context: RequestLessonPlanContextProtocol,
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
            self.instruments = instruments
                .map { instrument in
                    InstrumentViewData(name: instrument.name, icon: instrument.icon, action: {
                        self.context.instrument = instrument
                    })
                }
        }
    }
}
