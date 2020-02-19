import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class RequestLessonPlanViewModelTests: XCTestCase {
    func testInstrumentSelectionIsFirstView() {
        let instrumentProvider = InstrumentProviderStub(instruments: [Instrument(id: "ABC", name: "Violin", icon: Image(systemSymbol: ._00Circle))])
        let viewModel = RequestLessonPlanViewModel(instrumentProvider: instrumentProvider)
        XCTAssertNotNil(viewModel.viewData.instrumentSelectionView)
        XCTAssertNil(viewModel.viewData.studentDetailsView)
        XCTAssertNil(viewModel.viewData.addressDetailsView)
        XCTAssertNil(viewModel.viewData.schedulingView)
        XCTAssertNil(viewModel.viewData.privateNoteView)
        XCTAssertNil(viewModel.viewData.reviewProposalView)
    }
}
