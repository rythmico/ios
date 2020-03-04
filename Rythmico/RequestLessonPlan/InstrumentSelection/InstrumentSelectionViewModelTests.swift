import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class InstrumentSelectionViewTests: XCTestCase {
    var instrumentSelectionView: (RequestLessonPlanContext, [Instrument], InstrumentSelectionView) {
        let context = RequestLessonPlanContext()
        let instruments = [
            Instrument(id: "ABC", name: "Violin", icon: Image(systemSymbol: ._00Circle)),
            Instrument(id: "DEF", name: "Guitar", icon: Image(systemSymbol: ._00CircleFill))
        ]
        let view = InstrumentSelectionView(context: context, instrumentProvider: InstrumentSelectionListProviderStub(instruments: instruments))

        return (context, instruments, view)
    }

    func testInstrumentsProvidedAppear() {
        let (_, instruments, view) = instrumentSelectionView

        XCTAssertView(view) { view in
            XCTAssertEqual(view.instruments.count, 2)

            XCTAssertEqual(view.instruments[0].name, instruments[0].name)
            XCTAssertEqual(view.instruments[0].icon, instruments[0].icon)

            XCTAssertEqual(view.instruments[1].name, instruments[1].name)
            XCTAssertEqual(view.instruments[1].icon, instruments[1].icon)
        }
    }

    func testInstrumentsSelectionSetsInstrumentInContext() {
        let (context, instruments, view) = instrumentSelectionView

        XCTAssertView(view) { view in
            XCTAssertNil(context.instrument)

            view.instruments[0].action?()
            XCTAssertEqual(context.instrument, instruments[0])

            view.instruments[1].action?()
            XCTAssertEqual(context.instrument, instruments[1])
        }
    }
}
