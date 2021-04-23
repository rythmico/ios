import XCTest
@testable import Rythmico
import struct SwiftUI.Image
import ViewInspector

extension InstrumentSelectionView: Inspectable {}

final class InstrumentSelectionViewTests: XCTestCase {
    var instrumentSelectionView: (RequestLessonPlanFlow, [Instrument], InstrumentSelectionView) {
        let flow = RequestLessonPlanFlow()
        let instruments: [Instrument] = [.guitar, .singing]
        Current.instrumentSelectionListProvider = InstrumentSelectionListProviderStub(instruments: instruments)
        let view = InstrumentSelectionView(
            state: .init(),
            setter: { flow.instrument = $0 }
        )
        return (flow, instruments, view)
    }

    func testInstrumentsProvidedAppear() {
        let (_, instruments, view) = instrumentSelectionView

        XCTAssertView(view) { view in
            XCTAssertEqual(view.state.instruments.count, 2)

            XCTAssertEqual(view.state.instruments[0].name, instruments[0].standaloneName)
            XCTAssertEqual(view.state.instruments[0].icon, instruments[0].icon)

            XCTAssertEqual(view.state.instruments[1].name, instruments[1].standaloneName)
            XCTAssertEqual(view.state.instruments[1].icon, instruments[1].icon)
        }
    }

    func testInstrumentsSelectionSetsInstrumentInContext() {
        let (flow, instruments, view) = instrumentSelectionView

        XCTAssertView(view) { view in
            XCTAssertNil(flow.instrument)

            view.state.instruments[0].action?()
            XCTAssertEqual(flow.instrument, instruments[0])

            view.state.instruments[1].action?()
            XCTAssertEqual(flow.instrument, instruments[1])
        }
    }
}
