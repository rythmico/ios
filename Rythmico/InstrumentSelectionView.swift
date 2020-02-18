import SwiftUI
import ViewModel

struct InstrumentSelectionViewData {
    var instruments: [InstrumentViewData] = []
}

struct InstrumentSelectionView: View, ViewModelable {
    private enum Const {
        static let horizontalPadding: CGFloat = 22
    }

    @ObservedObject var viewModel: InstrumentSelectionViewModel

    var body: some View {
        VStack {
            CollectionView(viewData.instruments, id: \.name) {
                InstrumentView(viewData: $0).padding(.horizontal, Const.horizontalPadding)
            }
        }
    }
}
