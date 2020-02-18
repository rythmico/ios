import SwiftUI
import ViewModel

typealias StudentDetailsView = AnyView
typealias AddressDetailsView = AnyView
typealias SchedulingView = AnyView
typealias PrivateNoteView = AnyView
typealias ReviewProposalView = AnyView

struct RequestLessonPlanViewData {
    var instrumentSelectionView: InstrumentSelectionView?
    var studentDetailsView: StudentDetailsView?
    var addressDetailsView: AddressDetailsView?
    var schedulingView: SchedulingView?
    var privateNoteView: PrivateNoteView?
    var reviewProposalView: ReviewProposalView?
}

struct RequestLessonPlanView: View, Identifiable, ViewModelable {
    private enum Const {
        static let closeButtonImageVerticalPadding: CGFloat = 12
        static let closeButtonImageHorizontalPadding: CGFloat = 28

        static let closeButtonTopPadding: CGFloat = 10
        static let closeButtonTrailingPadding: CGFloat = 16

        static let horizontalPadding: CGFloat = 20
    }

    let id = UUID()

    @Environment(\.betterSheetPresentationMode) private var presentationMode

    @ObservedObject var viewModel: RequestLessonPlanViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemSymbol: .xmark).font(.system(size: 21, weight: .semibold))
                        .padding(.vertical, Const.closeButtonImageVerticalPadding)
                        .padding(.horizontal, Const.closeButtonImageHorizontalPadding)
                        .offset(x: Const.closeButtonImageHorizontalPadding)
                }
                .accentColor(.rythmicoGray90)
                .accessibility(label: Text("Close lesson request screen"))
                .accessibility(hint: Text("Double tap to return to main screen"))
            }
            .padding(.top, Const.closeButtonTopPadding)
            .padding(.trailing, Const.closeButtonTrailingPadding)

            StepBar(1, of: 6).padding(.horizontal, Const.horizontalPadding)

            VStack(alignment: .leading, spacing: 16) {
                Text("Choose Instrument").rythmicoFont(.largeTitle)
                Text("Select one instrument").rythmicoFont(.body).foregroundColor(.rythmicoGray90)
            }
            .padding(.horizontal, Const.horizontalPadding)

            ZStack {
                viewData.instrumentSelectionView
                viewData.studentDetailsView
                viewData.addressDetailsView
                viewData.schedulingView
                viewData.privateNoteView
                viewData.reviewProposalView
            }
        }
    }
}

struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanView(viewModel: RequestLessonPlanViewModel())
    }
}
