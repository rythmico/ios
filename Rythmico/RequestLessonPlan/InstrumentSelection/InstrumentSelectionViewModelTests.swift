import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class InstrumentSelectionViewTests: XCTestCase {
    var instrumentSelectionView: (RequestLessonPlanContext, [Instrument], InstrumentSelectionView) {
        let context = RequestLessonPlanContext()
        let instruments: [Instrument] = [.guitarStub, .singingStub]
        let instrumentProvider = InstrumentSelectionListProviderStub(instruments: instruments)
        let view = InstrumentSelectionView(state: .init(), context: context, instrumentProvider: instrumentProvider)

        return (context, instruments, view)
    }

    func testInstrumentsProvidedAppear() {
        let (_, instruments, view) = instrumentSelectionView

        XCTAssertView(view) { view in
            XCTAssertEqual(view.state.instruments.count, 2)

            XCTAssertEqual(view.state.instruments[0].name, instruments[0].name)
            XCTAssertEqual(view.state.instruments[0].icon, instruments[0].icon)

            XCTAssertEqual(view.state.instruments[1].name, instruments[1].name)
            XCTAssertEqual(view.state.instruments[1].icon, instruments[1].icon)
        }
    }

    func testInstrumentsSelectionSetsInstrumentInContext() {
        let (context, instruments, view) = instrumentSelectionView

        XCTAssertView(view) { view in
            XCTAssertNil(context.instrument)

            view.state.instruments[0].action?()
            XCTAssertEqual(context.instrument, instruments[0])

            view.state.instruments[1].action?()
            XCTAssertEqual(context.instrument, instruments[1])
        }
    }
}
