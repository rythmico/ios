import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class RequestLessonPlanViewTests: XCTestCase {
    func testInstrumentSelectionIsFirstView() {
        let instrumentProvider = InstrumentSelectionListProviderStub(instruments: [Instrument(id: "ABC", name: "Violin", icon: Image(systemSymbol: ._00Circle))])
        let view = RequestLessonPlanView(instrumentProvider: instrumentProvider)
        XCTAssertNotNil(view.instrumentSelectionView)
    }

    // TODO: complete coverage
}
