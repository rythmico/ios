import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class RequestLessonPlanViewModelTests: XCTestCase {
    func testInstrumentSelectionIsFirstView() {
        let instrumentProvider = InstrumentProviderStub(instruments: [Instrument(id: "ABC", name: "Violin", icon: Image(systemSymbol: ._00Circle))])
        let viewModel = RequestLessonPlanViewModel(instrumentProvider: instrumentProvider)

        switch viewModel.viewData.currentStep {
        case .instrumentSelection:
            break
        default:
            XCTFail("Incorrect current step \(viewModel.viewData.currentStep)")
        }
    }
}
