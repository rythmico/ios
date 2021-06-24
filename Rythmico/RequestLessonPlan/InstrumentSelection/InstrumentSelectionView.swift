import SwiftUISugar

struct InstrumentSelectionView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var instruments: [InstrumentViewData] = []
    }

    @ObservedObject
    var state: ViewState
    var setter: Binding<Instrument>.Setter

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(
            title: "Choose Instrument",
            subtitle: "Select one instrument",
            spacing: .grid(3)
        ) {
            CollectionView(state.instruments, id: \.name, content: InstrumentView.init)
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
                        action: { setter(instrument) }
                    )
                }
        }
    }
}
