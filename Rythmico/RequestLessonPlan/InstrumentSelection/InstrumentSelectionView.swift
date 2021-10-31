import CoreDTO
import SwiftUIEncore

struct InstrumentSelectionView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var instruments: [Instrument] = []
    }

    @StateObject
    var coordinator = Current.availableInstrumentsFetchingCoordinator()
    @ObservedObject
    var state: ViewState
    var setter: Binding<Instrument>.Setter

    @ScaledMetric(relativeTo: .largeTitle)
    private var instrumentIconsWidth: CGFloat = .grid(12)

    let inspection = SelfInspection()
    var body: some View {
        ZStack {
            if coordinator.isLoading {
                ActivityIndicator(color: .rythmico.foreground).frame(maxHeight: .infinity)
            } else {
                TitleSubtitleContentView("Choose Instrument", "Select one instrument") { _ in
                    ScrollView {
                        SelectableLazyVGrid(
                            data: state.instruments,
                            action: setter,
                            content: InstrumentSelectionItemView.init
                        )
                    }
                }
                .transition(.opacity.animation(.rythmicoSpring(duration: .durationShort)))
            }
        }
        .testable(self)
        .onAppear(perform: coordinator.runToIdle)
        .onSuccess(coordinator) { state.instruments = $0 }
        .alertOnFailure(coordinator, onDismiss: coordinator.dismissFailure)
    }
}

#if DEBUG
struct InstrumentSelectionView_Preview: PreviewProvider {
    static var previews: some View {
        InstrumentSelectionView(state: .init(), setter: { _ in })
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
