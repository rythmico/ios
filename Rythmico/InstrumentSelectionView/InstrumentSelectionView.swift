import SwiftUI
import ViewModel

struct InstrumentSelectionViewData {
    var instruments: [InstrumentViewData] = []
}

struct InstrumentSelectionView: View, ViewModelable {
    @ObservedObject var viewModel: InstrumentSelectionViewModel

    var body: some View {
        TitleSubtitleContentView(title: "Choose Instrument", subtitle: "Select one instrument") {
            CollectionView(self.viewData.instruments, id: \.name) {
                InstrumentView(viewData: $0).padding(.horizontal, .spacingMedium)
            }
            .padding(.horizontal, -.spacingMedium)
        }
    }
}
