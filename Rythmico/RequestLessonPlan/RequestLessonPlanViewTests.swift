import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class RequestLessonPlanViewTests: XCTestCase {
    func testInstrumentSelectionIsFirstView() {
        let instrumentProvider = InstrumentSelectionListProviderStub(instruments: [.pianoStub])
        let view = RequestLessonPlanView(instrumentProvider: instrumentProvider)
        XCTAssertNotNil(view.instrumentSelectionView)
    }

    // TODO: complete coverage
}
