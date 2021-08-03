import SwiftUISugar

struct InstrumentSelectionView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var instruments: [Instrument] = []
    }

    @ObservedObject
    var state: ViewState
    var setter: Binding<Instrument>.Setter

    @ScaledMetric(relativeTo: .largeTitle)
    private var instrumentIconsWidth: CGFloat = .grid(12)

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(
            title: "Choose Instrument",
            subtitle: "Select one instrument",
            spacing: .grid(6)
        ) {
            ScrollView {
                SelectableLazyVGrid(
                    data: state.instruments,
                    id: \.self,
                    action: setter,
                    content: InstrumentSelectionItemView.init
                )
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
