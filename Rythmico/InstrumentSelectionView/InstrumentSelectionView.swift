import SwiftUI
import ViewModel

struct InstrumentSelectionViewData {
    var instruments: [InstrumentViewData] = []
}

struct InstrumentSelectionView: View, ViewModelable {
    private enum Const {
        static let horizontalPadding: CGFloat = 20
    }

    @ObservedObject var viewModel: InstrumentSelectionViewModel

    var body: some View {
        VStack(alignment: .leading) {
            TitleSubtitleView(title: "Choose Instrument", subtitle: "Select one instrument")
            CollectionView(viewData.instruments, id: \.name) {
                InstrumentView(viewData: $0).padding(.horizontal, Const.horizontalPadding)
            }
        }
    }
}
