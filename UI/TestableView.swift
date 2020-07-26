import SwiftUI
import Combine

final class Inspection<V> where V: View {
    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()

    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}

protocol TestableView: View {
    typealias SelfInspection = Inspection<Self>
    var inspection: SelfInspection { get }
}

extension View {
    func testable<TV: TestableView>(_ view: TV) -> some View {
        onReceive(view.inspection.notice) { view.inspection.visit(view, $0) }
    }
}
