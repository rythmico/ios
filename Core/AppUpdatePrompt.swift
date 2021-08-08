import SwiftUI

struct AppUpdatePrompt: View {
    private enum Const {
        static let testFlightAppURLScheme = URL(string: "itms-beta://")!
        static let testFlightAppId: App.ID = "899247664"
    }

    var appId: App.ID
    var appName: String
    var origin: App.Origin { Current.appOrigin() }

    @State private var isTestFlightAppInstalled = Current.urlOpener.canOpenURL(Const.testFlightAppURLScheme)

    var body: some View {
        NavigationView {
            VStack(spacing: .grid(4)) {
                Text("Please download the latest version of \(appName) to be able to continue.")
                    .appUpdatePromptDescription()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                #if RYTHMICO
                if shouldShowUpdateButton {
                    RythmicoButton("Update \(appName)", style: .primary()) {
                        Current.urlOpener.open(origin.url(forAppId: appId))
                    }
                } else {
                    RythmicoButton("Download the TestFlight App", style: .secondary()) {
                        Current.urlOpener.open(App.Origin.appStore.url(forAppId: Const.testFlightAppId))
                    }
                }
                #elseif TUTOR
                if shouldShowUpdateButton {
                    RythmicoButton("Update \(appName)", style: .primary()) {
                        Current.urlOpener.open(origin.url(forAppId: appId))
                    }
                } else {
                    RythmicoButton("Download the TestFlight App", style: .secondary()) {
                        Current.urlOpener.open(App.Origin.appStore.url(forAppId: Const.testFlightAppId))
                    }
                }
                #endif
            }
            .navigationBarTitle("Update Required")
            .navigationBarTitleDisplayMode(.large)
            .padding([.horizontal, .bottom], inset)
            .padding(.top, .grid(2))
            .multilineTextAlignment(.leading)
        }
        .onEvent(.appInForeground, perform: refreshTestFlightAppInstalledIfNeeded)
    }

    private var shouldShowUpdateButton: Bool {
        switch origin {
        case .testFlight:
            return isTestFlightAppInstalled
        case .appStore:
            return true
        }
    }

    private func refreshTestFlightAppInstalledIfNeeded() {
        switch origin {
        case .testFlight:
            isTestFlightAppInstalled = Current.urlOpener.canOpenURL(Const.testFlightAppURLScheme)
        case .appStore:
            break
        }
    }

    private var inset: CGFloat {
        #if RYTHMICO
        return .grid(5)
        #elseif TUTOR
        return 17
        #endif
    }
}

private extension Text {
    func appUpdatePromptDescription() -> some View {
        #if RYTHMICO
        self.rythmicoTextStyle(.body)
            .foregroundColor(.rythmico.foreground)
        #elseif TUTOR
        self.font(.body)
            .foregroundColor(.gray)
        #endif
    }
}

#if DEBUG
struct AppUpdatePrompt_Previews: PreviewProvider {
    static var previews: some View {
        Current.urlOpener = URLOpenerSpy(canOpenURLs: false)
        return AppUpdatePrompt(appId: App.id, appName: App.name)
//            .environment(\.colorScheme, .dark)
    }
}
#endif
