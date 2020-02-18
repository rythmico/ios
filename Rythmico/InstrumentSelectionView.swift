import SwiftUI
import ViewModel

struct InstrumentSelectionViewData {
    var instruments: [InstrumentViewData] = []
}

struct InstrumentSelectionView: View, ViewModelable {

    @ObservedObject var viewModel: InstrumentSelectionViewModel

    var body: some View {
        VStack {
            CollectionView(viewData.instruments, id: \.name) {
                InstrumentView(viewData: $0).padding(.horizontal, 22)
            }
        }
    }
}
