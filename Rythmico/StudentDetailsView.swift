import SwiftUI
import ViewModel

struct StudentDetailsViewData {
    var selectedInstrumentName: String
}

struct StudentDetailsView: View, ViewModelable {
    private enum Const {
        static let horizontalPadding: CGFloat = 22
    }

    @ObservedObject var viewModel: StudentDetailsViewModel

    var body: some View {
        VStack {
            TitleSubtitleView(
                title: "Student Details",
                subtitle: [.regular("Enter the details of the student who will learn "), .bold(viewData.selectedInstrumentName)]
            )
            Spacer()
        }
    }
}
