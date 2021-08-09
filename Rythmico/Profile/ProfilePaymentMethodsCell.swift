import SwiftUISugar
import ComposableNavigator

struct ProfilePaymentMethodsCell: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var body: some View {
        ProfileCell("Payment Methods", disclosure: true) {
            navigator.go(to: PaymentMethodsScreen(), on: currentScreen)
        }
    }
}
