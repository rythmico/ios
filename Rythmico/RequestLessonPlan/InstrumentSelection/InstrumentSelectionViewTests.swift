import CoreDTO
@testable import Rythmico
import struct SwiftUI.Image
import ViewInspector
import XCTest

extension InstrumentSelectionView: Inspectable {}

final class InstrumentSelectionViewTests: XCTestCase {
    var instrumentSelectionView: (RequestLessonPlanFlow, [Instrument], InstrumentSelectionView) {
        let flow = RequestLessonPlanFlow()
        let instruments = [.guitar, .singing].map(Instrument.stub)
        Current.stubAPIEndpoint(for: \.availableInstrumentsFetchingCoordinator, result: .success(instruments))
        let view = InstrumentSelectionView(
            state: .init(),
            setter: { flow.instrument = $0 }
        )
        return (flow, instruments, view)
    }

    func testInstrumentsProvidedAppear() {
        let (_, instruments, view) = instrumentSelectionView

        XCTAssertView(view) { view in
            XCTAssertEqual(view.state.instruments, instruments)
        }
    }
}
