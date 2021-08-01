import SwiftUISugar

struct InstrumentSelectionView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var instruments: [Instrument] = []
    }

    @ObservedObject
    var state: ViewState
    var setter: Binding<Instrument>.Setter

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(
            title: "Choose Instrument",
            subtitle: "Select one instrument",
            spacing: .grid(6)
        ) {
            ScrollView {
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(minimum: 0, maximum: 200), spacing: .grid(3)),
                        count: 2
                    ),
                    spacing: .grid(3)
                ) {
                    ForEach(state.instruments, id: \.self) { instrument in
                        InstrumentButton(instrument: instrument) {
                            setter(instrument)
                        }
                    }
                }
                .padding([.horizontal, .bottom], .grid(5))
            }
        }
        .testable(self)
        .onAppear(perform: fetchInstruments)
    }

    private func fetchInstruments() {
        Current.instrumentSelectionListProvider.instruments { state.instruments = $0 }
    }
}

#if DEBUG
struct InstrumentSelectionView_Preview: PreviewProvider {
    static var previews: some View {
        let state = InstrumentSelectionView.ViewState()
        state.instruments = Instrument.allCases
        return InstrumentSelectionView(state: state, setter: { _ in })
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
