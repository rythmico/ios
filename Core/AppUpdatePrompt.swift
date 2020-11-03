import SwiftUI

extension App {
    enum DistributionMethod: Equatable, Hashable {
        case testFlight
        case appStore

        func url(forAppId appId: String) -> URL {
            switch self {
            case .testFlight:
                return URL(string: "itms-beta://beta.itunes.apple.com/v1/app/\(appId)")!
            case .appStore:
                return URL(string: "https://apps.apple.com/app/id\(appId)")!
            }
        }
    }
}

struct AppUpdatePrompt: View {
    private enum Const {
        static let testFlightAppURLScheme = URL(string: "itms-beta://")!
        static let testFlightAppId = "899247664"
    }
    var appId: String
    var method: App.DistributionMethod

    @State private var isTestFlightAppInstalled = Current.urlOpener.canOpenURL(Const.testFlightAppURLScheme)

    var body: some View {
        NavigationView {
            VStack(spacing: .spacingSmall) {
                Text("Please download the latest version of \(App.name) to access all the latest features.")
                    .modifier(AppUpdatePromptDescriptionModifier())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                if shouldShowUpdateButton {
                    Button("Update \(App.name)") {
                        Current.urlOpener.open(method.url(forAppId: appId))
                    }
                    .primaryStyle()
                } else {
                    Button("Download the TestFlight App") {
                        Current.urlOpener.open(App.DistributionMethod.appStore.url(forAppId: Const.testFlightAppId))
                    }
                    .secondaryStyle()
                }
            }
            .navigationTitle("Update Required")
            .navigationBarTitleDisplayMode(.large)
            .padding([.horizontal, .bottom], inset)
            .padding(.top, .spacingUnit * 2)
            .multilineTextAlignment(.leading)
            .lineSpacing(.spacingUnit * 1.5)
        }
        .onEvent(.appInForeground, perform: refreshTestFlightAppInstalledIfNeeded)
    }

    private var shouldShowUpdateButton: Bool {
        switch method {
        case .testFlight:
            return isTestFlightAppInstalled
        case .appStore:
            return true
        }
    }

    private func refreshTestFlightAppInstalledIfNeeded() {
        switch method {
        case .testFlight:
            isTestFlightAppInstalled = Current.urlOpener.canOpenURL(Const.testFlightAppURLScheme)
        case .appStore:
            break
        }
    }

    private var inset: CGFloat {
        #if RYTHMICO
        return .spacingMedium
        #elseif TUTOR
        return 17
        #endif
    }
}

private struct AppUpdatePromptDescriptionModifier: ViewModifier {
    #if RYTHMICO
    func body(content: Content) -> some View {
        content
            .rythmicoFont(.body)
            .foregroundColor(.rythmicoGray90)
    }
    #elseif TUTOR
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(.gray)
    }
    #endif
}

#if DEBUG
struct AppUpdatePrompt_Previews: PreviewProvider {
    static var previews: some View {
        Current.urlOpener = URLOpenerSpy(canOpenURLs: false)
        return AppUpdatePrompt(appId: App.id, method: App.distributionMethod)
//            .environment(\.colorScheme, .dark)
    }
}
#endif
