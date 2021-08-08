import SwiftUISugar
import ComposableNavigator

struct PaymentMethodsScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                PaymentMethodsScreen.self,
                content: { PaymentMethodsView() }
            )
        }
    }
}

struct PaymentMethodsView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    @StateObject
    private var coordinator = Current.customerPortalURLFetchingCoordinator()
    @StateObject
    private var webViewStore = WebViewStore()

    var body: some View {
        ZStack {
            if isLoading {
                ActivityIndicator()
            } else {
                RythmicoWebView(backgroundColor: .rythmico.background, store: webViewStore, onDone: back)
            }
        }
        .backgroundColor(.rythmico.background)
        .frame(maxHeight: .infinity, alignment: .center)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchCustomerPortalURL)
        .onSuccess(coordinator, perform: onCustomerPortalURLFetched)
        .animation(.rythmicoSpring(duration: .durationShort), value: isLoading)
    }

    private var isLoading: Bool {
        coordinator.state.isLoading || webViewStore.isLoading
    }

    private func fetchCustomerPortalURL() {
        coordinator.runToIdle()
    }

    private func onCustomerPortalURLFetched(_ customerPortal: StripeCustomerPortal) {
        webViewStore.webView.load(customerPortal.url)
    }

    private func back() {
        navigator.dismiss(screen: currentScreen)
    }
}

#if DEBUG
struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodsView()
    }
}
#endif
