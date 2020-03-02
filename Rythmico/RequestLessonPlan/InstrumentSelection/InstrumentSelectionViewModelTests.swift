import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class InstrumentSelectionViewModelTests: XCTestCase {
    func testInstrumentsProvidedAppear() {
        let context = RequestLessonPlanContext()
        let instrumentProvider = InstrumentSelectionListProviderStub(instruments: [
            Instrument(id: "ABC", name: "Violin", icon: Image(systemSymbol: ._00Circle)),
            Instrument(id: "DEF", name: "Guitar", icon: Image(systemSymbol: ._00CircleFill))
        ])
        let viewModel = InstrumentSelectionViewModel(context: context, instrumentProvider: instrumentProvider)

        XCTAssertEqual(viewModel.viewData.instruments.count, 2)

        XCTAssertEqual(viewModel.viewData.instruments[0].name, "Violin")
        XCTAssertEqual(viewModel.viewData.instruments[0].icon, Image(systemSymbol: ._00Circle))

        XCTAssertEqual(viewModel.viewData.instruments[1].name, "Guitar")
        XCTAssertEqual(viewModel.viewData.instruments[1].icon, Image(systemSymbol: ._00CircleFill))
    }
}
