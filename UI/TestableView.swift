import SwiftUI

protocol TestableView: View {
    var didAppear: ((Self) -> Void)? { get set }
}
