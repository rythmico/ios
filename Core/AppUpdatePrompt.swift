import SwiftUIEncore

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
        titleSubtitleAndContent("Update Required", "Please download the latest version of \(appName) to be able to continue.") { padding in
            VStack(spacing: 0) {
                Spacer()
                if shouldShowUpdateButton {
                    RythmicoButton("Update \(appName)", style: .primary()) {
                        Current.urlOpener.open(origin.url(forAppId: appId))
                    }
                } else {
                    RythmicoButton("Download the TestFlight App", style: .secondary()) {
                        Current.urlOpener.open(App.Origin.appStore.url(forAppId: Const.testFlightAppId))
                    }
                }
            }
            .multilineTextAlignment(.leading)
        }
        .onAppEvent(.willEnterForeground, perform: refreshTestFlightAppInstalledIfNeeded)
    }

    @ViewBuilder
    private func titleSubtitleAndContent<Content: View>(
        _ title: String,
        _ subtitle: String,
        content: @escaping (HorizontalInsets) -> Content
    ) -> some View {
        NavigationView {
            #if RYTHMICO
            TitleSubtitleContentView(title, subtitle) { padding in
                content(padding).padding([.horizontal, .bottom], padding.leading)
            }
            .navigationBarTitleDisplayMode(.inline)
            #elseif TUTOR
            VStack(spacing: .grid(4)) {
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.gray)
                    .lineSpacing(.grid(1))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                content(.zero)
            }
            .padding([.horizontal, .bottom], 17)
            .navigationBarTitle(title)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
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
