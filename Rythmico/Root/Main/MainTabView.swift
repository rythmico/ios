import SwiftUI
import class FirebaseAuth.Auth
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView {
    private let accessTokenProvider: AuthenticationAccessTokenProvider

    @State private(set) var lessonRequestView: RequestLessonPlanView?

    func presentRequestLessonFlow() {
        lessonRequestView = RequestLessonPlanView(
            viewModel: .init(instrumentProvider: InstrumentSelectionListProviderFake())
        )
    }

    init(accessTokenProvider: AuthenticationAccessTokenProvider) {
        self.accessTokenProvider = accessTokenProvider
    }

    var didAppear: Handler<Self>?
    var body: some View {
        TabView {
            NavigationView {
                Color.clear
                    .navigationBarTitle("Lessons", displayMode: .large)
                    .navigationBarItems(
                        trailing: Button(action: presentRequestLessonFlow) {
                            Image(systemSymbol: .plusCircleFill).font(.system(size: 24))
                                .padding(.vertical, .spacingExtraSmall)
                                .padding(.horizontal, .spacingExtraLarge)
                                .offset(x: .spacingExtraLarge)
                        }
                        .accessibility(label: Text("Request lessons"))
                        .accessibility(hint: Text("Double tap to request a lesson plan"))
                    )
            }
            .tabItem {
                Image(systemSymbol: .calendar).font(Font.system(size: 21, weight: .medium))
                Text("LESSONS")
            }

            NavigationView {
                Form {
                    Button(action: { try! Auth.auth().signOut() }) {
                        HStack {
                            Spacer()
                            Text("Log out").rythmicoFont(.body).foregroundColor(.rythmicoRed)
                            Spacer()
                        }
                    }
                    .frame(minHeight: 35)
                    .accessibility(hint: Text("Double tap to log out of your account"))
                }
                .navigationBarTitle(Text("Profile"), displayMode: .large)
            }
            .tabItem {
                Image(systemSymbol: .person).font(Font.system(size: 21, weight: .semibold))
                Text("PROFILE")
            }
        }
        .accentColor(.rythmicoPurple)
        .betterSheet(item: $lessonRequestView, content: { $0 })
        .onAppear { self.didAppear?(self) }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(accessTokenProvider: AuthenticationAccessTokenProviderDummy())
    }
}
