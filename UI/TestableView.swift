import SwiftUI

protocol TestableView: View {
    var onAppear: ((Self) -> Void)? { get set }
}
